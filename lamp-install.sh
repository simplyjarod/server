#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi


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

# CentOS 6 installation:
if [ "$centos_version" -eq 6 ]; then
	yum install mysql mysql-server -y

# CentOS 7 installation:
else
	yum install mariadb mariadb-server -y
fi

yum install MySQL-python -y

# CentOS 6 installation:
if [ "$centos_version" -eq 6 ]; then
	service mysqld start
	chkconfig --levels 235 mysqld on

# CentOS 7 installation:
else
	service mariadb start 
	chkconfig --levels 235 mariadb on
fi

/usr/bin/mysql_secure_installation


###################################
echo "***** PHP INSTALLATION *****"
###################################

yum install php php-mysql php-mysqli php-gd php-xml php-mbstring php-mcrypt* php-soap php-mbstring -y
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
service mysqld restart


echo "***** READY! ALL DONE ;) *****"
