#!/bin/sh

if [ "$1" = "nginx" ]; then
	echo "Create default.conf:"
	echo ""
	echo " - CLIENT_MAX_BODY_SIZE: ${CLIENT_MAX_BODY_SIZE}"
	echo " - PS_FOLDER_ADMIN: ${PS_FOLDER_ADMIN}"
	echo " - PS_DOMAIN: ${PS_DOMAIN}"
	echo ""

	envsubst '${CLIENT_MAX_BODY_SIZE} ${PS_FOLDER_ADMIN} ${PS_DOMAIN}' \
		< /etc/nginx/conf.d/default.conf.template \
		> /etc/nginx/conf.d/default.conf
fi

exec "$@"
