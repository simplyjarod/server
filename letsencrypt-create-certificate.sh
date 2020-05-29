#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi

centos_version=$(rpm -qa \*-release | grep -Ei "oracle|redhat|centos" | cut -d"-" -f3)


if [ "$centos_version" -eq 6 ]; then
	wget https://dl.eff.org/certbot-auto
	mv certbot-auto /usr/local/bin/certbot-auto
	chown root /usr/local/bin/certbot-auto
	chmod 0755 /usr/local/bin/certbot-auto
	/usr/local/bin/certbot-auto --nginx
	echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && /usr/local/bin/certbot-auto renew -q" | sudo tee -a /etc/crontab > /dev/null
	
elif [ "$centos_version" -eq 7 ]; then
	yum install certbot python2-certbot-nginx
	certbot --nginx
	echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q" | sudo tee -a /etc/crontab > /dev/null
	
elif [ "$centos_version" -eq 8 ]; then
	dnf install certbot python3-certbot-nginx
	certbot --nginx
	echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q" | sudo tee -a /etc/crontab > /dev/null
else
	echo -e "\e[91mERROR: This script is not ready for your OS\e[0m"
	exit 1
fi
