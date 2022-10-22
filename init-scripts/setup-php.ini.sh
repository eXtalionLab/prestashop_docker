#!/usr/bin/env bash

echo "Setup php.ini..."

PHP_INI_RECOMMENDED="$PHP_INI_DIR/php.ini-production"

if [ $PS_DEV_MODE -eq 1 ]; then
    echo "php.ini for development"
    PHP_INI_RECOMMENDED="$PHP_INI_DIR/php.ini-development"
fi

ln -sf "$PHP_INI_RECOMMENDED" "$PHP_INI_DIR/php.ini"
