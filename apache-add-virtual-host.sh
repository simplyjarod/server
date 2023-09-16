#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi


if [ -z $1 ]; then # no hay parametros en la llamada, los pedimos por pantalla:

	echo "Public web folder will be /home/user_name/public_html"
	read -r -e -p "Set user name (user will be created if does not exist): " username
	user=${username,,} # tolower

	read -r -e -p "Set domain name (do not write http or www) (e.g. domain.com): " domain
	domain=${domain,,} # tolower

elif [ $# -ne 2 ]; then # hay parametros, pero no hay 2
	echo "Usage: $0 user_name domain"
	exit 65 #bad args

else
	user=$1
	domain=$2
fi


# Install apache if it is not installed yet:
if [ ! -x "$(command -v apache2)" ]; then
	./apache-install.sh
fi

# If the user does not exist it will be created:
id -u $user &>/dev/null || useradd $user

mkdir -p /home/$user/public_html
cp php/index.php /home/$user/public_html
chown -R $user:$user /home/$user/public_html

#chmod +x /home/$user  # apache2 needs to execute here????????????

# apache2 virtual host config file:
if [ -x "$(command -v apt-get)" ]; then
	file_name="${domain//./}"; # removes dots from domain

	echo "<VirtualHost *:80>
	ServerName ${domain}
	DocumentRoot /home/${user}/public_html

	ErrorLog /var/log/apache2/${user}-error.log
	CustomLog /var/log/apache2/${user}-access.log combined

	<Directory /home/${user}/public_html>
		AllowOverride All
		Require all granted
	</Directory>
</VirtualHost>" >> /etc/apache2/sites-available/$file_name.conf

	# Install php if it is not installed yet:
	if [ ! -x "$(command -v php)" ]; then
		./php-install.sh
	fi
	
	# Setup php:
	php_version=$(php -v | head -1 | cut -d " " -f 2 | cut -d "." -f 1-2)

	\cp /etc/php/$php_version/fpm/pool.d/www.conf /etc/php/$php_version/fpm/pool.d/$user.conf

	sed -i -e "/\[www\]/s/^.*$/[$user]/" /etc/php/$php_version/fpm/pool.d/$user.conf
	sed -i -e "/^listen =/s/^.*$/listen = \/run\/php\/$user.sock/" /etc/php/$php_version/fpm/pool.d/$user.conf
	sed -i -e "/^user =/s/^.*$/user = $user/" /etc/php/$php_version/fpm/pool.d/$user.conf
	sed -i -e "/^group =/s/^.*$/group = $user/" /etc/php/$php_version/fpm/pool.d/$user.conf

	# mkdir /var/lib/php/session-$user
	# chmod -R 700 /var/lib/php/session-$user # only for sockets
	# chown -R $user:nobody /var/lib/php/session-$user # only for sockets

	service php$php_version-fpm restart

	a2ensite $file_name.conf
	systemctl restart apache2

else
	echo -e "\e[91mUnsupported system. Please install apache manually.\e[0m"
	exit 1
fi
