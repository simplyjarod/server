#!/bin/bash

centos_version=$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos" | cut -d"-" -f3)

#
echo "***** INSTALACION DE NGINX *****"
#
yum install epel-release -y # nginx is not available straight from CentOS
yum install nginx -y
\cp nginx/nginx.conf /etc/nginx/
\cp nginx/security.inc /etc/nginx/conf.d/
\cp nginx/logging.inc /etc/nginx/conf.d/
#mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.old

# Diffie-Hellman cipher:
mkdir /etc/nginx/ssl
openssl dhparam -out /etc/nginx/ssl/dhparams.pem 2048

chkconfig --levels 235 nginx on



#
echo "***** INSTALACION MYSQL/MARIADB *****"
#

if [ "$centos_version" -eq 6 ]; then
	yum install mysql mysql-server -y
else
	yum install mariadb mariadb-server -y # for centos 7
fi

yum install MySQL-python -y

if [ "$centos_version" -eq 6 ]; then
	service mysqld start
	chkconfig --levels 235 mysqld on
else
	service mariadb start # for centos 7
	chkconfig --levels 235 mariadb on
fi

/usr/bin/mysql_secure_installation



#
echo "***** INSTALACION DE PHP *****"
#
yum install php php-fpm php-mysql php-mysqli php-gd php-xml php-mbstring php-mcrypt* php-soap php-mbstring -y
\cp php/php.ini /etc/
\cp php/www.conf /etc/php-fpm.d/
chown root:nginx /var/lib/php/session/
chmod 777 /var/lib/php/session/
echo "extension='/usr/lib/php/modules/soap.so'" >> /etc/php.ini

service php-fpm start
chkconfig --levels 235 php-fpm on



#
#echo "***** INSTALACION DE PHP-MYADMIN *****"
#
#yum install phpmyadmin -y



# Creamos nuevo virtual host:
./nginx-add-virtual-host.sh



#
echo "***** CONFIGURANDO FIREWALL (:80) *****"
#
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
service iptables save



#
echo "***** REINICIANDO SERVIDORES... *****"
#
service nginx restart
service php-fpm restart
service mysqld restart

echo "***** FINALIZADO!! TODO LISTO!! *****"
