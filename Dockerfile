# the different stages of this Dockerfile are meant to be built into separate images
# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target


# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG PS_VERSION=1.7-7.2


# "prestashop" stage
FROM prestashop/prestashop:${PS_VERSION}-fpm AS prestashop


RUN set -eux; \
	\
	ln -srf $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini
COPY docker/prestashop/conf.d/prestashop.ini $PHP_INI_DIR/conf.d/zzz-prestashop.ini
COPY docker/prestashop/php-fpm.d/prestashop.conf $PHP_INI_DIR/../php-fpm.d/zzz-prestashop.conf


RUN set -eux; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		acl \
	; \
	rm -rf /var/lib/apt/lists/*

ARG APCU_VERSION=5.1.20
RUN set -eux; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		$PHPIZE_DEPS \
	; \
	\
	pecl install \
		apcu-${APCU_VERSION} \
	; \
	pecl clear-cache; \
	docker-php-ext-enable \
		apcu \
	; \
	\
	# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html


COPY docker/prestashop/entrypoint.sh /prestashop-entrypoint.sh

RUN set -eux; \
    \
    chmod +x /prestashop-entrypoint.sh


ENTRYPOINT ["/prestashop-entrypoint.sh"]
CMD ["/tmp/docker_run.sh"]
