#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi

centos_version=$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos" | sed 's/[^6-8]*//g' | cut -c1)


#####################################
echo "***** NGINX INSTALLATION *****"
#####################################

yum -y install epel-release || amazon-linux-extras install epel -y # nginx is not available straight from CentOS
yum install nginx -y
\cp nginx/nginx.conf /etc/nginx/
\cp nginx/security.inc /etc/nginx/conf.d/
\cp nginx/logging.inc /etc/nginx/conf.d/
\cp nginx/wordpress.inc /etc/nginx/conf.d/
#mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.old
mv 404.html /usr/share/nginx/html -f
mv 50x.html /usr/share/nginx/html -f

# Diffie-Hellman cipher:
mkdir /etc/nginx/ssl
openssl dhparam -out /etc/nginx/ssl/dhparams.pem 2048

chkconfig --levels 235 nginx on


#############################################
echo "***** MYSQL/MARIADB INSTALLATION *****"
#############################################
./mariadb-install.sh


###################################
echo "***** PHP INSTALLATION *****"
###################################

yum install php php-fpm php-mysqli php-gd php-xml php-mbstring php-soap php-bcmath -y
if [ "$centos_version" -le 7 ]; then
	yum install php-mysql php-mcryp* -y
else
	yum install php-json -y
fi
\cp php/php.ini /etc/
\cp php/www.conf /etc/php-fpm.d/
chown root:nginx /var/lib/php/session/
chmod 777 /var/lib/php/session/
echo "extension='/usr/lib/php/modules/soap.so'" >> /etc/php.ini

service php-fpm start
chkconfig --levels 235 php-fpm on

./php-update.sh


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
service php-fpm restart
service mysql restart


echo "***** READY! ALL DONE ;) *****"
