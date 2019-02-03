#!/bin/bash

# More info at https://mariadb.com/kb/en/library/yum/

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi

centos_version=$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos" | cut -d"-" -f3)


#########################
# CentOS 6 installation #
#########################
if [ "$centos_version" -eq 6 ]; then
	
	yum install epel-release -y
	yum install mysql mysql-server -y

	chkconfig --levels 235 mysqld on
	service mysqld start
	/usr/bin/mysql_secure_installation
	service mysqld restart


#########################
# CentOS 7 installation #
#########################
else

	cat >/etc/yum.repos.d/MariaDB.repo << EOL
	[mariadb]
	name = MariaDB
	baseurl = http://yum.mariadb.org/10.3/centos7-amd64
	gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
	gpgcheck=1
	EOL
  rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
	
	yum update -y
	
	#yum remove MariaDB-Galera-server -y # If the server already has the MariaDB-Galera-server package installed, then you might need to remove it prior to installing the MariaDB-server package
	yum install MariaDB-server MariaDB-client -y
	
	systemctl enable mysql # or chkconfig mariadb on
	systemctl start mysql
	mysql_secure_installation
	systemctl restart mysql
fi
