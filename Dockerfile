#syntax=docker/dockerfile:1.4

# Adapted from https://github.com/dunglas/symfony-docker


# Versions
# hadolint ignore=DL3007
FROM prestashop/prestashop:1.7-fpm AS prestashop_upstream
FROM composer/composer:2-bin AS composer_upstream
FROM mlocati/php-extension-installer AS php_extension_installer_upstream


# The different stages of this Dockerfile are meant to be built into separate images
# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target


# Base prestashop image
FROM prestashop_upstream as prestashop_base

WORKDIR /var/www/html

# persistent / runtime deps
# hadolint ignore=DL3008
RUN apt-get update; \
	apt-get install -y --no-install-recommends \
		acl \
		busybox-static \
		git \
		ncat \
		supervisor \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# php extensions installer: https://github.com/mlocati/docker-php-extension-installer
COPY --from=php_extension_installer_upstream --link /usr/bin/install-php-extensions /usr/local/bin/

RUN set -eux; \
	install-php-extensions \
		apcu \
		mysqli \
		opcache \
		redis \
	;

COPY --link docker/prestashop/conf.d/prestashop.ini $PHP_INI_DIR/conf.d/zzz-prestashop.ini
COPY --link docker/prestashop/php-fpm.d/prestashop.conf $PHP_INI_DIR/../php-fpm.d/zzz-prestashop.conf

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/root/.composer/vendor/bin"

COPY --from=composer_upstream --link /composer /usr/bin/composer

###> ioncube ###
ARG PS_PHP_VERSION=7.4
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
	mkdir -p /var/spool/cron/crontabs; \
	mkdir -p /var/log/supervisord; \
	mkdir -p /var/run/supervisord

COPY --link docker/prestashop/supervisord.conf /
COPY --link docker/prestashop/cron.sh /cron.sh

RUN chmod +x /cron.sh
###< cron ###

###> custom ###
###< custom ###

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]

# Dev prestashop image
FROM prestashop_base AS prestashop_dev

ENV PS_DEV_MODE=1 SYMFONY_DEBUG=1 SYMFONY_ENV=dev XDEBUG_MODE=develop

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN apt-get update; \
	apt-get install -y --no-install-recommends \
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

ENV PS_DEV_MODE=0 SYMFONY_DEBUG=0 SYMFONY_ENV=prod

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY --link docker/prestashop/conf.d/prestashop.prod.ini $PHP_INI_DIR/conf.d/zzz-prestashop.prod.ini
