#!/usr/bin/env bash

echo "Install modules..."

autoupgrade_version=${AUTOUPGRADE_VERSION:-v6.3.0}
fop_console_version=${FOP_CONSOLE_VERSION:-1.5.0}

mkdir -p /tmp/modules;

if [[ ! -d "/var/www/html/modules/autoupgrade" ]]; then
	echo "Install autoupgrade:${autoupgrade_version}"

	wget https://github.com/PrestaShop/autoupgrade/releases/download/${autoupgrade_version}/autoupgrade-${autoupgrade_version}.zip \
		--output-document /tmp/modules/autoupgrade.zip
	unzip /tmp/modules/autoupgrade.zip -d /var/www/html/modules
	/var/www/html/bin/console prestashop:module install autoupgrade
fi

if [[ ! -d "/var/www/html/modules/fop_console" ]]; then
	echo "Install fop_console:${fop_console_version}"

	wget https://github.com/friends-of-presta/fop_console/releases/download/${fop_console_version}/fop_console.zip \
		--output-document /tmp/modules/fop_console.zip
	unzip /tmp/modules/fop_console.zip -d /var/www/html/modules
	/var/www/html/bin/console prestashop:module install fop_console
fi

rm -rf /tmp/modules
