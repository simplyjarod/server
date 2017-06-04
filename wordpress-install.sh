#!/bin/bash

# si no hay parametros en la llamada los pedimos por pantalla:
if [ -z $2 ]; then
	read -r -p "Absolute path to install Wordpress in (e.g. /home/user/public_html): " path
	read -r -p "User name for permission purposes (e.g. nginx): " user
else
	path=$1
	user=$2
fi


# if path does not exist, we will try to create it
if [ ! -d "$path" ]; then
	read -r -p "Path does not exists. Create it? [Y/n]: " create_path
	create_path=${create_path,,} # tolower

	if [[ $create_path =~ ^(no|n)$ ]]
	then
		exit 1
	else
		mkdir -p $path
	fi

fi


# wordpress installation:
if ! type -path "wget" > /dev/null 2>&1; then yum install wget -y; fi
wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
rm -f latest.tar.gz
mv wordpress/* $path/.
rm -rf wordpress

chmod 000 $path/xmlrpc.php # some basic security


chown $user:$user $path # set the proper permissions to the folder itself
chown -R $user:$user $path/* # set the proper permissions to all the wordpress files


# wordpress database installation and configuration:
dbname=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
dbuser=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
dbpass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
./mysql-create-db-and-user.sh $dbname $dbuser $dbpass

sed -i "s|database_name_here|$dbname|g" $path/wp-config-sample.php
sed -i "s|username_here|$dbuser|g" $path/wp-config-sample.php
sed -i "s|password_here|$dbpass|g" $path/wp-config-sample.php

mv $path/wp-config-sample.php $path/wp-config.php
