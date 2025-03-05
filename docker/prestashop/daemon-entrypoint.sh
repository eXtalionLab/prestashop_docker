#!/bin/sh
set -e

if [ "$1" = 'php' ] || [ "$1" = 'bin/console' ] || [ "$1" = 'supervisord' ]; then
	echo "Waiting for php to be ready..."
	ATTEMPTS_LEFT_TO_REACH_PHP=60
	until [ $ATTEMPTS_LEFT_TO_REACH_PHP -eq 0 ] || PHP_ERROR=$(cgi-fcgi -bind -connect /var/run/php/php-fpm.sock 2>/dev/null); do
		sleep 1
		ATTEMPTS_LEFT_TO_REACH_PHP=$((ATTEMPTS_LEFT_TO_REACH_PHP - 1))
		echo "Still waiting for php to be ready... $ATTEMPTS_LEFT_TO_REACH_PHP attempts left."
	done

	if [ $ATTEMPTS_LEFT_TO_REACH_PHP -eq 0 ]; then
		echo "The php is not up or not reachable:"
		echo "$PHP_ERROR"
		exit 1
	else
		echo "The php is now ready and reachable"
	fi

	mkdir -p var/cache var/log
	setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX var
	setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX var
fi

exec docker-php-entrypoint "$@"
