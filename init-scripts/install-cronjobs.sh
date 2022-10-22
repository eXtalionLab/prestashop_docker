#!/usr/bin/env bash

echo "Install cronjobs..."

cronjobs_file="/cronjobs/jobs"

if [[ ! -f "$cronjobs_file" ]]; then
    echo "File \"${cronjobs_file}\" not found, skip."

    exit 0;
fi

cp "$cronjobs_file" "/var/spool/cron/crontabs/www-data"

echo "Add +x to all files in \"/cronjobs/*.sh\""
chmod +x /cronjobs/*.sh
