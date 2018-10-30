#!/bin/bash

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

chmod +x /home/$user  # nginx no funcionara si no puede ejecutar aqui


# The default server root directory is /usr/share/nginx/html
mkdir -p /home/$user/public_html
cp php/index.php /home/$user/public_html
chown -R $user:$user /home/$user/public_html


# Copy and customization of nginx config file:
\cp nginx/default.conf /etc/nginx/conf.d/$user.conf
sed -i "s|CHANGE_THIS_USER_NAME|$user|g" /etc/nginx/conf.d/$user.conf

sed -i "s|CHANGE_THIS_DOMAIN_NAME|$domain|g" /etc/nginx/conf.d/$user.conf


# Copy and customization of php-fpm pool config file:
#\cp php/pool.conf /etc/php-fpm.d/$user.conf # only for sockets
#sed -i "s|CHANGE_THIS_USER_NAME|$user|g" /etc/php-fpm.d/$user.conf # only for sockets

#mkdir /var/lib/php/session-$user # only for sockets
#chmod -R 700 /var/lib/php/session-$user # only for sockets
#chown -R $user:nobody /var/lib/php/session-$user # only for sockets


service nginx restart
service php-fpm restart
