#!/usr/bin/env bash

rm_redis_config() {
    rm -f "${PHP_INI_DIR}/conf.d/redis.ini"

    exit
}

nc -z "${REDIS_HOST}" 6379 || rm_redis_config

echo "Setup redis as session handler..."

if [ "${REDIS_HOST}" == "" ] || [ "${REDIS_HOST_PASSWORD}" == "" ]; then
    echo "REDIS_HOST or REDIS_HOST_PASSWORD not setup, skip"

    rm_redis_config
fi

cat << REDIS_CONF > "${PHP_INI_DIR}/conf.d/redis.ini"
session.save_handler = redis
session.save_path = "tcp://${REDIS_HOST}:6379?auth=${REDIS_HOST_PASSWORD}"
redis.session.locking_enabled = 1
redis.session.lock_retries = -1
# redis.session.lock_wait_time is specified in microseconds.
# Wait 10ms before retrying the lock rather than the default 2ms.
redis.session.lock_wait_time = 10000
REDIS_CONF
