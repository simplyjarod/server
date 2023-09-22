#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi


if [ -x "$(command -v yum)" ]; then
	yum -y install epel-release || amazon-linux-extras install epel -y # nginx is not available straight from CentOS
	yum install nginx -y
	\cp nginx/nginx.conf /etc/nginx/
	mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.old

	# Diffie-Hellman cipher:
	mkdir /etc/nginx/ssl
	openssl dhparam -out /etc/nginx/ssl/dhparams.pem 2048

	chkconfig --levels 235 nginx on

elif [ -x "$(command -v apt-get)" ]; then
	apt-get install nginx -y

	sed -i '/http {/a\\tclient_max_body_size 100M;\n' /etc/nginx/nginx.conf

	sed -i '/http {/a\\tlog_format custom_access "$remote_addr ($http_x_forwarded_for) [$time_local] req:\\"$request\\" code:\\"$status\\" sentB:\\"$body_bytes_sent\\" ref:\\"$http_referer\\" agent:\\"$http_user_agent\\" host:\\"$host\\"";\n' /etc/nginx/nginx.conf

	sed -i '/http {/a\\tindex index.php index.html index.htm;\n' /etc/nginx/nginx.conf
	sed -i '/http {/a\\tkeepalive_timeout 7;' /etc/nginx/nginx.conf
	sed -i '/http {/a\\tcharset utf-8;' /etc/nginx/nginx.conf

	sed -i -e '/\(#\|\)\s*server_tokens/s/^.*$/\tserver_tokens off; # hide nginx version/' /etc/nginx/nginx.conf

	sed -i '/gzip on/a\\tgzip_disable "MSIE [1-6]\.(?!.*SV1)";' /etc/nginx/nginx.conf
	sed -i -e '/\(#\|\)\s*gzip_http_version/s/^.*$/\tgzip_http_version 1.1;/' /etc/nginx/nginx.conf
	sed -i -e '/\(#\|\)\s*gzip_comp_level/s/^.*$/\tgzip_comp_level 6;/' /etc/nginx/nginx.conf
	sed -i -e '/\(#\|\)\s*gzip_buffers/s/^.*$/\tgzip_buffers 16 8k;/' /etc/nginx/nginx.conf
	sed -i -e '/\(#\|\)\s*gzip_proxied/s/^.*$/\tgzip_proxied any;/' /etc/nginx/nginx.conf
	sed -i -e '/\(#\|\)\s*gzip_types/s/^.*$/\tgzip_types text\/plain text\/css text\/xml  text\/x-component text\/javascript application\/javascript application\/x-javascriptapplication\/xml application\/xhtml+xml application\/xml+rss application\/json application\/x-font-ttf application\/x-font-opentype application\/vnd.ms-fontobject image\/svg+xml image\/x-icon image\/bmp;/' /etc/nginx/nginx.conf

	# remove default site config file from sites-enabled:
	rm -f /etc/nginx/sites-enabled/default

	# server to avoid access without domain (with IP):
	echo "server {
	listen 80;
	server_name _; # no server name
	return 444; # "No response" error
}" >> /etc/nginx/sites-available/block-nodomain.conf
	ln -s /etc/nginx/sites-available/block-nodomain.conf /etc/nginx/sites-enabled/block-nodomain.conf

	# remove apache2:
	service apache2 stop
	apt-get purge apache2 -y
	apt-get autoremove -y

else
	echo -e "\e[91mUnsupported system. Please install nginx manually.\e[0m"
	exit 1
fi


\cp nginx/security.inc /etc/nginx/conf.d/
\cp nginx/logging.inc /etc/nginx/conf.d/
\cp nginx/wordpress.inc /etc/nginx/conf.d/

mv 40*.html /usr/share/nginx/html -f
mv 50x.html /usr/share/nginx/html -f


service nginx restart
