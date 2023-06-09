info() {
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] INFO - $1"
}

get_log_file() {
    local root_path="$1"
    local script_name="$2"

    log_dir="${root_path}/log/${script_name}"

    if [[ ! -d "$log_dir" ]]; then
        mkdir -p "$log_dir"
    fi

    echo "${log_dir}/$(date "+%Y-%m-%d").log"
}

dont_run_on_localhost() {
    local domain
    domain=$(get_domain)

    if [[ "$domain" == "nginx" ]]; then
        echo "Skip run on localhost"

        exit 0
    fi
}

get_admin_folder() {
    if [[ "$PS_FOLDER_ADMIN" == "" ]]; then
        echo "admin"
    fi

    echo "$PS_FOLDER_ADMIN"
}

get_admin_dir() {
    admin_folder=$(get_admin_folder)

    echo "/var/www/html/${admin_folder}"
}

get_schema() {
    schema='https'

    if [[ $PS_ENABLE_SSL -eq 0 ]]; then
        schema='http'
    fi

    echo "$schema"
}

get_domain() {
    if [[ "$PS_DOMAIN" == "" ]]; then
        echo "Unknown domain name. Set PS_DOMAIN env"

        exit 1
    fi

    domain="${PS_DOMAIN}"

    # In docker "localhost" server for prestashop service is nginx service
    if [[ "${domain}" == "localhost" ]]; then
        domain='nginx'
    fi

    schema=$(get_schema)

    echo "$schema://$domain"
}

get_script_name() {
    local script_name
    script_name="$(basename "$1" ".sh")"

    echo "$script_name"
}

get_module_dir() {
    local script_name="$1"

    echo "/var/www/html/modules/${script_name%%-*}"
}

bin_console() {
    php /var/www/html/bin/console "$@"
}

run_cronitor() {
    call_cronitor "$1" "run"
}

complete_cronitor() {
    call_cronitor "$1" "complete"
}

fail_cronitor() {
    call_cronitor "$1" "fail"
}

call_cronitor() {
    if [[ "$CRONITOR_KEY" == "" ]]; then
        echo "Cronitor skip. CRONITOR_KEY not set"

        return
    fi

    local monitorKey="$1"

    if [[ "$monitorKey" == "" ]]; then
        echo "\$monitorKey is required"

        return
    fi

    local state="$2"

    if [[ "$state" != "run"
        && "$state" != "complete"
        && "$state" != "fail"
        && "$state" != "ok"
    ]]; then
        echo "Allowed values for \$state are: run, complete, fail, ok"

        return
    fi

    curl -Ls \
        "https://cronitor.link/p/${CRONITOR_KEY}/${monitorKey}?state=${state}"
}

run_sentry() {
    call_sentry "$1" "in_progress"
}

complete_sentry() {
    call_sentry "$1" "ok" "$2" "$3" >> /dev/null
}

fail_sentry() {
    call_sentry "$1" "error" "$2" "$3"
}

call_sentry() {
    if [[ "$SENTRY_DSN" == "" ]]; then
        echo "Sentry skip. SENTRY_DSN not set"

        return
    fi

    local monitorId="$1"

    if [[ "$monitorId" == "" ]]; then
        echo "\$monitorId is required"

        return
    fi

    local status="$2"

    if [[ "$status" != "in_progress"
        && "$status" != "error"
        && "$status" != "ok"
    ]]; then
        echo "Allowed values for \$status are: in_progress, ok, error"

        return
    fi

    local method='POST'
    local checkInId="$3"

    if [[ "$status" != "in_progress" ]]; then
        if [[ "$checkInId" == '' ]]; then
            echo "checked_in_id is required"

            return
        fi

        method='PUT'
        checkInId="${checkInId}/"
    fi

    local data="{\"status\": \"$status\"}"
    local duration="$4"

    if [[ "$duration" != "" ]]; then
        data="{\"status\": \"$status\", \"duration\":$duration}"
    fi

    response="$(curl -Ls \
        -X "$method" \
        "https://sentry.io/api/0/monitors/$monitorId/checkins/$checkInId" \
        --header "Authorization: DSN $SENTRY_DSN" \
        --header 'Content-Type: application/json' \
        --data-raw "$data")"

    echo "$(echo "$response" | awk -F'"' '{print $4}')"
}
