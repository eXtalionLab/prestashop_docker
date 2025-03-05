#!/usr/bin/env bash

echo "Setup email..."

email_envs=(
	"PS_MAIL_DOMAIN"
	"PS_MAIL_SMTP_ENCRYPTION"
	"PS_MAIL_SMTP_PORT"
	"PS_MAIL_METHOD"
	"PS_MAIL_PASSWD"
	"PS_MAIL_SERVER"
	"PS_MAIL_USER"
)

for env in "${email_envs[@]}"; do
	if [[ "${!env}" != "" ]]; then
		echo "${env}: ${!env}"
		/var/www/html/bin/console prestashop:config set "${env}" --value "${!env}" -q
	else
		echo "${env}: is not set"
	fi
done
