#syntax=docker/dockerfile:1.4

# Adapted from https://github.com/dunglas/symfony-docker


# Versions
# hadolint ignore=DL3007
FROM prestashop/prestashop:8.2-fpm AS prestashop_upstream
FROM composer/composer:2-bin AS composer_upstream
FROM mlocati/php-extension-installer AS php_extension_installer_upstream


# The different stages of this Dockerfile are meant to be built into separate images
# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target


# Base prestashop image
FROM prestashop_upstream AS prestashop_base

WORKDIR /var/www/html

# persistent / runtime deps
# hadolint ignore=DL3008
RUN apt-get update && apt-get install --no-install-recommends -y \
		acl \
		busybox-static \
		git \
		libfcgi-bin \
		supervisor \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

# php extensions installer: https://github.com/mlocati/docker-php-extension-installer
COPY --from=php_extension_installer_upstream /usr/bin/install-php-extensions /usr/local/bin/

RUN set -eux; \
	install-php-extensions \
		apcu \
		mysqli \
		opcache \
		redis \
	;

COPY --link docker/prestashop/conf.d/prestashop.ini $PHP_INI_DIR/conf.d/zzz-prestashop.ini
COPY --link docker/prestashop/php-fpm.d/prestashop.conf $PHP_INI_DIR/../php-fpm.d/zzz-prestashop.conf
ENV PATH="${PATH}:/root/.composer/vendor/bin"

COPY --from=composer_upstream /composer /usr/bin/composer

###> ioncube ###
ARG PS_PHP_VERSION=8.1
ARG IONCUB_VERSION=lin_x86-64
RUN set -eux; \
	\
	curl \
		-o ioncube.tar.gz \
		https://downloads.ioncube.com/loader_downloads/ioncube_loaders_${IONCUB_VERSION}.tar.gz \
	&& tar -xzf ioncube.tar.gz \
	&& mv ioncube/ioncube_loader_lin_${PS_PHP_VERSION}.so `php-config --extension-dir` \
	&& rm -Rf ioncube.tar.gz ioncube \
	&& docker-php-ext-enable ioncube_loader_lin_${PS_PHP_VERSION}
###< ioncube ###

###> cron ###
RUN set -eux; \
	\
	mkdir -p /var/spool/cron/crontabs

COPY --link --chmod=755 docker/prestashop/cron.sh /cron.sh
COPY --link --chmod=755 docker/prestashop/daemon-entrypoint.sh /usr/local/bin/daemon-entrypoint
COPY --link docker/prestashop/daemon-supervisor.conf /etc/supervisor/conf.d/daemon.conf
###< cron ###

###> custom ###
###< custom ###

HEALTHCHECK --start-period=60s CMD cgi-fcgi -bind -connect /var/run/php/php-fpm.sock || exit 1

# Dev prestashop image
FROM prestashop_base AS prestashop_dev

ENV APP_ENV=dev PS_DEV_MODE=1 XDEBUG_MODE=develop

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
		rsync \
		zip \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN set -eux; \
	install-php-extensions \
		xdebug \
	;

COPY --link docker/prestashop/conf.d/prestashop.dev.ini $PHP_INI_DIR/conf.d/zzz-prestashop.dev.ini

# Prod prestashop image
FROM prestashop_base AS prestashop_prod

ENV APP_ENV=prod PS_DEV_MODE=0

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY --link docker/prestashop/conf.d/prestashop.prod.ini $PHP_INI_DIR/conf.d/zzz-prestashop.prod.ini
