#!/bin/sh

if [ "$1" = "nginx" ]; then
    echo "Create default.conf"

    envsubst '${PS_FOLDER_ADMIN}' \
        < /etc/nginx/conf.d/default.conf.template \
        > /etc/nginx/conf.d/default.conf
fi

exec "$@"
