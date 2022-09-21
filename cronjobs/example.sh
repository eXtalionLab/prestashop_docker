#!/usr/bin/env bash

root_path=$(dirname "$0")

# shellcheck source=helper
source "${root_path}/helper.sh"

script_name=$(get_script_name "$0")
log_file="$(get_log_file "${root_path}" "${script_name}")"

# Uncomment if you don't want to run job on localhost
#dont_run_on_localhost

# Uncomment to monitor job with cronitor
# See https://cronitor.io
#run_cronitor "$script_name"

# Your cron job
# use http
domain=$(get_domain)
admin_folder=$(get_admin_folder)

#echo "" >> "${log_file}"
#info "Rebuild search index" >> "${log_file}"
#curl -Ls \
#    "${domain}/${admin_folder}/index.php?controller=AdminSearch&action=searchCron&ajax=1&full=1&token=CHANGE_ME&id_shop=1" \
#    >> "${log_file}" 2>&1

# use cli
module_dir="$(get_module_dir "$script_name")" # /var/www/html/modules/modulename
admin_dir="$(get_admin_dir)"                  # /var/www/html/adminxyz

#echo "" >> "${log_file}"
#info "Update currency rates" >> "${log_file}"
#php ${admin_dir}/cron_currency_rates.php \
#    secure_key=CHANGE_ME \
#    >> "${log_file}" 2>&1

# use bin/console
app_command="swiftmailer:spool:send"

#echo "" >> "${log_file}"
#info "Send emails from the spool" >> "${log_file}"
#bin_console ${app_command} \
#    --no-ansi \
#    >> "${log_file}" 2>&1
# END Your cron job

# Uncomment to monitor job with cronitor
#complete_cronitor "$script_name"
