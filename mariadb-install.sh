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

	yum install mariadb-server -y
	
	centos_version=$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos" | sed 's/[^6-8]*//g' | cut -c1)

	# CentOS 6 installation
	if [ "$centos_version" -eq 6 ]; then
		chkconfig --levels 235 mysql on
		service mysql start
		mysql_secure_installation
		service mysql restart

	# CentOS 7+ installation
	else
		systemctl enable mariadb
		systemctl start mariadb.service
		mysql_secure_installation
		systemctl restart mariadb
	fi

elif [[ $os =~ "ubuntu" ]]; then # $os contains "ubuntu"

	apt install mariadb-server -y
	
	mysql_secure_installation
	systemctl enable mariadb
	systemctl start mariadb
	systemctl restart mariadb
fi
