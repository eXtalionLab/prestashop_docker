#!/bin/sh

if [ "$1" = "nginx" ]; then
    echo "Create default.conf"

    envsubst '${CLIENT_MAX_BODY_SIZE} ${PS_FOLDER_ADMIN} ${PS_DOMAIN}' \
        < /etc/nginx/conf.d/default.conf.template \
        > /etc/nginx/conf.d/default.conf
fi

exec "$@"
