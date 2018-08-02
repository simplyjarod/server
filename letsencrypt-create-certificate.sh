#!/bin/bash

# MANY THANKS TO: http://www.tecmint.com/setup-https-with-lets-encrypt-ssl-certificate-for-nginx-on-centos/


# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi


read -r -p "Domain/s to setup SSL: (space separated - e.g.: 'jarod.es www.jarod.es blog.jarod.es') " domain
domain=$(echo $domain | sed 's/ / -d /g')


# CONTINUE OR NOT?
read -r -p "Proceed with certificate installation for $domain? (nginx will be stopped) [y/N] " response
res=${response,,} # tolower
if ! [[ $res =~ ^(yes|y)$ ]]
then
	echo "Process aborted"
	exit 1
fi

yum install epel-release -y
yum install git -y

git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt

service nginx stop # yes, port 80 has to be unused while the installation
iptables -I INPUT -p tcp --dport 443 -j ACCEPT
service iptables save

/opt/letsencrypt/letsencrypt-auto certonly --standalone -d $domain

service nginx start

echo "##################################"
echo "YOU NEED TO CHANGE FOLLOWING LINE AT /etc/nginx/conf.d/xxxxxxx.conf"
echo ">>>listen 80;<<< to >>>listen 443;<<<"
echo ""
echo "##################################"
echo "YOU NEED TO ADD FOLLOWING LINES AT /etc/nginx/conf.d/xxxxxxx.conf"
echo "ssl on;"
echo "ssl_certificate /etc/letsencrypt/live/YOUR_DOMAIN_HERE/fullchain.pem;"
echo "ssl_certificate_key /etc/letsencrypt/live/YOUR_DOMAIN_HERE/privkey.pem;"
echo ""
echo "CHECK THIS CERTIFICATE ON: https://www.ssllabs.com/ssltest/analyze.html"
