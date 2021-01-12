#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi

centos_version=$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos" | sed 's/[^6-8]*//g' | cut -c1)

yum install mariadb-server -y


#########################
# CentOS 6 installation #
#########################
if [ "$centos_version" -eq 6 ]; then

	chkconfig --levels 235 mysql on
	service mysql start
	mysql_secure_installation
	service mysql restart

###########################
# CentOS 7/8 installation #
###########################
else
	
	systemctl enable mariadb
	systemctl start mariadb.service
	mysql_secure_installation
	systemctl restart mariadb
fi
