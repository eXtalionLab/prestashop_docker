#!/bin/sh

if [ "$1" = "/tmp/docker_run.sh" ]; then
	PHP_INI_RECOMMENDED="$PHP_INI_DIR/php.ini-production"

	if [ $PS_DEV_MODE -eq 1 ]; then
		PHP_INI_RECOMMENDED="$PHP_INI_DIR/php.ini-development"
	fi

	ln -sf "$PHP_INI_RECOMMENDED" "$PHP_INI_DIR/php.ini"

	setfacl -R -m u:www-data:rX -m u:"$(whoami)":rwX .
	setfacl -dR -m u:www-data:rX -m u:"$(whoami)":rwX .
fi

exec "$@"
