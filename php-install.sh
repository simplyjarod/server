#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi

# Operative System:
os=$(grep ^ID= /etc/os-release | cut -d "=" -f 2)
os=${os,,} #tolower


if [[ $os =~ "centos" ]]; then # $os contains "centos"
	
	centos_version=$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos" | sed 's/[^6-8]*//g' | cut -c1)
	
	yum install php php-fpm php-mysqli php-gd php-xml php-mbstring php-soap php-bcmath -y
	if [ "$centos_version" -le 7 ]; then
		yum install php-mysql php-mcryp* -y
	else
		yum install php-json -y
	fi
	\cp php/php.ini /etc/
	\cp php/www.conf /etc/php-fpm.d/
	chown root:nginx /var/lib/php/session/
	chmod 777 /var/lib/php/session/
	echo "extension='/usr/lib/php/modules/soap.so'" >> /etc/php.ini

	service php-fpm start
	chkconfig --levels 235 php-fpm on

	./php-update.sh
	
elif [[ $os =~ "ubuntu" ]]; then # $os contains "ubuntu"

	apt install php php-fpm php-mysql php-mysqli php-curl php-gd php-xml php-mbstring php-soap php-bcmath -y

	php_version=$(php -v | head -1 | cut -d " " -f 2 | cut -d "." -f 1-2)

	sed -i -e '/\(;\|\)\s*short_open_tag =/s/^.*$/short_open_tag = On/' /etc/php/$php_version/fpm/php.ini
	sed -i -e '/\(;\|\)\s*max_execution_time =/s/^.*$/max_execution_time = 60/' /etc/php/$php_version/fpm/php.ini
	sed -i -e '/\(;\|\)\s*max_input_time =/s/^.*$/max_input_time = 60/' /etc/php/$php_version/fpm/php.ini
	sed -i -e '/\(;\|\)\s*max_input_vars =/s/^.*$/max_input_vars = 5000/' /etc/php/$php_version/fpm/php.ini
	sed -i -e '/\(;\|\)\s*memory_limit =/s/^.*$/memory_limit = 128M/' /etc/php/$php_version/fpm/php.ini
	sed -i -e '/\(;\|\)\s*post_max_size =/s/^.*$/post_max_size = 100M/' /etc/php/$php_version/fpm/php.ini
	sed -i -e '/\(;\|\)\s*upload_max_filesize =/s/^.*$/upload_max_filesize = 100M/' /etc/php/$php_version/fpm/php.ini
	sed -i -e '/\(;\|\)\s*date.timezone =/s/^.*$/date.timezone = "Europe\/Madrizzzz"/' /etc/php/$php_version/fpm/php.ini

	#\cp php/www.conf /etc/php/$php_version/fpm/pool.d/

	service php$php_version-fpm restart

else
	echo -e "\e[91mOS not detected. Nothing was done\e[0m"
	exit 1
fi

php -v
