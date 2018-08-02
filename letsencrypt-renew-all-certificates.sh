#!/bin/bash

# MANY THANKS TO: http://www.tecmint.com/setup-https-with-lets-encrypt-ssl-certificate-for-nginx-on-centos/


# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi

yum install epel-release -y
yum install git -y

git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt

service nginx stop # yes, port 80 has to be unused while the installation

/opt/letsencrypt/letsencrypt-auto renew

service nginx start
