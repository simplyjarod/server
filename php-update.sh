#!/bin/bash

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

  rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-7.rpm
  
#########################
# CentOS 7 installation #
#########################
else

  rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
  rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-6.rpm

fi

# get the latest version remi-php file (ie. remi-php74.repo)
repofile=$(ls /etc/yum.repos.d/remi-php*.repo -r | head -1)
# change the enabled bit from 0 to 1 and enable the mirrorlist (only first occurrence)
sed -i "0,/enabled=0/s/enabled=0/enabled=1/" $repofile
sed -i "0,/#mirrorlist/s/#mirrorlist/mirrorlist/" $repofile


yum upgrade php* -y

service php-fpm restart
service nginx restart

php -v
