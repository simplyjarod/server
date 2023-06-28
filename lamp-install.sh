#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi


if ! [ -x "$(command -v yum)" ]; then
	echo -e "\e[91mUnsupported system. Please install apache manually.\e[0m"
	exit 1
fi


centos_version=$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos" | cut -d"-" -f3)


######################################
echo "***** APACHE INSTALLATION *****"
######################################

yum install -y httpd
\cp apache/httpd.conf /etc/httpd/conf/httpd.conf
# to do: borrar welcome.conf, configurar errores, .htaccess...

service httpd start
chkconfig --levels 235 httpd on


#############################################
echo "***** MYSQL/MARIADB INSTALLATION *****"
#############################################
./mariadb-install.sh


###################################
echo "***** PHP INSTALLATION *****"
###################################

yum install php php-mysql php-mysqli php-gd php-xml php-mbstring php-mcrypt* php-soap php-mbstring php-bcmath -y
\cp php/php.ini /etc/php.ini
\cp php/index.php /var/www/html/index.php

service php start
chkconfig --levels 235 php on


############################################
#echo "***** PHP-MYADMIN INSTALLATION *****"
############################################

#yum install phpmyadmin -y
#\cp phpmyadmin/phpMyAdmin.conf /etc/httpd/conf.d/phpMyAdmin.conf


########################################
echo "***** RESTARTING SERVERS... *****"
########################################

service httpd restart
service php restart
service mysql restart


echo "***** READY! ALL DONE ;) *****"
