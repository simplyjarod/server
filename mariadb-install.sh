#!/bin/bash
# More info at https://mariadb.com/kb/en/library/yum/

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi

centos_version=$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos" | cut -d"-" -f3)


# baseurl = http://yum.mariadb.org/10.3/centos6-amd64
# baseurl = http://yum.mariadb.org/10.3/centos7-amd64
cat >/etc/yum.repos.d/MariaDB.repo << EOL
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3/centos$centos_version-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOL

rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB

yum update -y

yum install MariaDB-server MariaDB-client -y


#########################
# CentOS 6 installation #
#########################
if [ "$centos_version" -eq 6 ]; then

	chkconfig --levels 235 mysql on
	service mysql start
	mysql_secure_installation
	service mysql restart

#########################
# CentOS 7 installation #
#########################
else
	
	systemctl enable mysql # or chkconfig --levels 235 mysql on
	systemctl start mysql
	mysql_secure_installation
	systemctl restart mysql
fi
