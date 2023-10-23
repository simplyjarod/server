#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi


######################################
echo "***** APACHE INSTALLATION *****"
######################################
./apache-install.sh


#############################################
echo "***** MYSQL/MARIADB INSTALLATION *****"
#############################################
./mysql-install.sh


###################################
echo "***** PHP INSTALLATION *****"
###################################
./php-install.sh


############################
# Set up a new virtual host:
############################
./apache-add-virtual-host.sh


if [ -x "$(command -v iptables)" ]; then
###########################################
echo "***** FIREWALL SETUP (port 80) *****"
###########################################

./iptables-accept-http.sh \*
fi


########################################
echo "***** RESTARTING SERVERS... *****"
########################################

service apache2 restart

if [ -x "$(command -v yum)" ]; then
	service php-fpm restart
elif [ -x "$(command -v apt-get)" ]; then
	php_version=$(php -v | head -1 | cut -d " " -f 2 | cut -d "." -f 1-2)
	service php$php_version-fpm restart
fi

service mysql restart


echo "***** READY! ALL DONE ;) *****"
