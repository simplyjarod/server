#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi

centos_version=$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos" | cut -d"-" -f3)


#####################################
echo "***** NGINX INSTALLATION *****"
#####################################

yum install epel-release -y # nginx is not available straight from CentOS
yum install nginx -y
\cp nginx/nginx.conf /etc/nginx/
\cp nginx/security.inc /etc/nginx/conf.d/
\cp nginx/logging.inc /etc/nginx/conf.d/
\cp nginx/wordpress.inc /etc/nginx/conf.d/
#mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.old

# Diffie-Hellman cipher:
mkdir /etc/nginx/ssl
openssl dhparam -out /etc/nginx/ssl/dhparams.pem 2048

chkconfig --levels 235 nginx on


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
	systemctl start mariadb
	chkconfig --levels 235 mariadb on
fi

/usr/bin/mysql_secure_installation


###################################
echo "***** PHP INSTALLATION *****"
###################################

yum install php php-fpm php-mysql php-mysqli php-gd php-xml php-mbstring php-mcrypt* php-soap php-mbstring -y
\cp php/php.ini /etc/
\cp php/www.conf /etc/php-fpm.d/
chown root:nginx /var/lib/php/session/
chmod 777 /var/lib/php/session/
echo "extension='/usr/lib/php/modules/soap.so'" >> /etc/php.ini

service php-fpm start
chkconfig --levels 235 php-fpm on


############################
# Set up a new virtual host:
############################

./nginx-add-virtual-host.sh


if type -path "iptables" > /dev/null 2>&1; then
###########################################
echo "***** FIREWALL SETUP (port 80) *****"
###########################################

./iptables-accept-http.sh *
fi


########################################
echo "***** RESTARTING SERVERS... *****"
########################################

service nginx restart
service php-fpm restart
service mysqld restart


echo "***** READY! ALL DONE ;) *****"
