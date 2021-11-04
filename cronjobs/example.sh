#!/usr/bin/env bash

root_path=$(dirname "$0")

# shellcheck source=helper
source "${root_path}/helper"

script_name=$(get_script_name "$0")

# Uncomment if you don't want to run job on localhost
#dont_run_on_localhost

# Uncomment to monitor job with cronitor
# See https://cronitor.io
#run_cronitor "$script_name"

schema=$(get_schema)
domain=$(get_domain)
admin_folder=$(get_admin_folder)

# Your cron job
token="CHANGE_ME!"

echo "Rebuild search index"
#curl -Ls "${schema}://${domain}/${admin_folder}/index.php?controller=AdminSearch&action=searchCron&ajax=1&full=1&token=${token}&id_shop=1"
# END Your cron job

# Uncomment to monitor job with cronitor
#complete_cronitor "$script_name"
