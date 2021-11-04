#!/bin/sh

if [ "$1" = "/usr/bin/supervisord" ]; then
	PHP_INI_RECOMMENDED="$PHP_INI_DIR/php.ini-production"

	if [ $PS_DEV_MODE -eq 1 ]; then
		PHP_INI_RECOMMENDED="$PHP_INI_DIR/php.ini-development"
	fi

	ln -sf "$PHP_INI_RECOMMENDED" "$PHP_INI_DIR/php.ini"

	setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX .
	setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX .

	cronjobsFile="/cronjobs/jobs"

	if [ -f "$cronjobsFile" ]; then
		echo "Install cron jobs"
		cp "$cronjobsFile" "/var/spool/cron/crontabs/www-data"
		chmod +x /cronjobs/*.sh
	else
		echo "File ${cronjobsFile} not found, skip."
	fi
fi

exec "$@"
