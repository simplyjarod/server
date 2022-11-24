#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi

# Operative System:
os=$(grep ^ID= /etc/os-release | cut -d "=" -f 2)
os=${os,,} #tolower

if [ -z $1 ]; then # no hay parametros en la llamada, los pedimos por pantalla:

	echo "Public web folder will be /home/user_name/public_html"
	read -r -p "Set user name (user will be created if does not exist): " username
	user=${username,,} # tolower

	read -r -p "Set domain name (do not write http or www) (e.g. domain.com): " domain
	domain=${domain,,} # tolower

elif [ $# -ne 2 ]; then # hay parametros, pero no hay 2
	echo "Usage: $0 user_name domain"
	exit 65 #bad args

else
	user=$1
	domain=$2
fi


# If the user does not exist it will be created:
id -u $user &>/dev/null || useradd $user

mkdir -p /home/$user/public_html
cp php/index.php /home/$user/public_html
chown -R $user:$user /home/$user/public_html

chmod +x /home/$user  # nginx needs to execute here


# nginx virtual host config file:
if [[ $os =~ "centos" ]]; then # $os contains "centos"

	\cp nginx/default.conf /etc/nginx/conf.d/$user.conf
	sed -i "s|CHANGE_THIS_USER_NAME|$user|g" /etc/nginx/conf.d/$user.conf

	sed -i "s|CHANGE_THIS_DOMAIN_NAME|$domain|g" /etc/nginx/conf.d/$user.conf

elif [[ $os =~ "ubuntu" ]]; then # $os contains "ubuntu"

	\cp nginx/default.conf /etc/nginx/sites-available/$user.conf
	sed -i "s|CHANGE_THIS_USER_NAME|$user|g" /etc/nginx/sites-available/$user.conf

	sed -i "s|CHANGE_THIS_DOMAIN_NAME|$domain|g" /etc/nginx/sites-available/$user.conf

	sed -i -e "/[^#]fastcgi_pass/s/^.*$/\t\tfastcgi_pass unix:\/run\/php\/$user.sock;/" /etc/nginx/sites-available/$user.conf

	ln -s /etc/nginx/sites-available/$user.conf /etc/nginx/sites-enabled

fi


# php-fpm pool config file:
if [[ $os =~ "centos" ]]; then # $os contains "centos"
	\cp php/pool.conf /etc/php-fpm.d/$user.conf
	sed -i "s|CHANGE_THIS_USER_NAME|$user|g" /etc/php-fpm.d/$user.conf

	mkdir /var/lib/php/session-$user
	chmod -R 700 /var/lib/php/session-$user # only for sockets
	chown -R $user:nobody /var/lib/php/session-$user # only for sockets

	service php-fpm restart

elif [[ $os =~ "ubuntu" ]]; then # $os contains "ubuntu"

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

fi

service nginx restart
