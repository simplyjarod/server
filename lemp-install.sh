#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi

# Operative System:
os=$(grep ^ID= /etc/os-release | cut -d "=" -f 2)
os=${os,,} #tolower

#centos_version=$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos" | sed 's/[^6-8]*//g' | cut -c1)


#####################################
echo "***** NGINX INSTALLATION *****"
#####################################
./nginx-install.sh


#############################################
echo "***** MYSQL/MARIADB INSTALLATION *****"
#############################################
./mariadb-install.sh


###################################
echo "***** PHP INSTALLATION *****"
###################################
./php-install.sh


############################
# Set up a new virtual host:
############################
./nginx-add-virtual-host.sh


if type -path "iptables" > /dev/null 2>&1; then
###########################################
echo "***** FIREWALL SETUP (port 80) *****"
###########################################

./iptables-accept-http.sh \*
fi


########################################
echo "***** RESTARTING SERVERS... *****"
########################################

service nginx restart

if [[ $os =~ "centos" ]]; then # $os contains "centos"
	service php-fpm restart
elif [[ $os =~ "ubuntu" ]]; then # $os contains "ubuntu"
	php_version=$(php -v | head -1 | cut -d " " -f 2 | cut -d "." -f 1-2)
	service php$php_version-fpm restart
fi

service mysql restart


echo "***** READY! ALL DONE ;) *****"
