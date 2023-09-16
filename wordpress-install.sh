#!/bin/bash

# si no hay parametros en la llamada los pedimos por pantalla:
if [ -z $2 ]; then
	read -r -e -p "Absolute path to install Wordpress in (e.g. /home/user/public_html): " path
	read -r -e -p "User name for permission purposes (e.g. nginx): " user
else
	path=$1
	user=$2
fi

path="${path%/}" # removes last slash

if [ -z $5 ]; then
	read -r -p "Set custom DB name, user and pass? If not, a new DB will be created with random name. [Y/n]: " custom_db_names
	custom_db_names=${custom_db_names,,} # tolower

	if [[ $custom_db_names =~ ^(no|n)$ ]]; then
		dbname=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
		dbuser=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
		dbpass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)	
	else
		echo "DB will be created if it does not exist."
		read -r -e -p "Name of DataBase: " dbname
		read -r -e -p "Name of DB User: " dbuser
		read -s -p "Password for DB User $dbuser: " dbpass
		echo "" # we need a new line after the password
	fi
else
	dbname=$3
	dbuser=$4
	dbpass=$5
fi


# if path does not exist, we will try to create it
if [ ! -d "$path" ]; then
	read -r -p "Path does not exists. Create it? [Y/n]: " create_path
	create_path=${create_path,,} # tolower

	if [[ $create_path =~ ^(no|n)$ ]]; then
		exit 1
	else
		mkdir -p $path
	fi
fi


# WordPress installation (we need to download it from wordpress.org):

# Check if wget is installed and try to install it if possible:
if ! command -v wget &>/dev/null; then
	if [ -x "$(command -v apt-get)" ]; then
		apt-get update && apt-get install wget -y
	elif [ -x "$(command -v yum)" ]; then
		yum install wget -y
	else
		echo -e "\e[91mUnsupported system. Please install wget manually and re-run this script again.\e[0m"
		exit 1
	fi
fi

# WordPress download:
wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
rm -f latest.tar.gz
mv wordpress/* $path/.
rm -rf wordpress

chown $user:$user $path # set the proper permissions to the folder itself
chown -R $user:$user $path/* # set the proper permissions to all the wordpress files


# wordpress database installation and configuration:
./mysql-create-db-and-user.sh $dbname $dbuser $dbpass

sed -i "s|database_name_here|$dbname|g" $path/wp-config-sample.php
sed -i "s|username_here|$dbuser|g" $path/wp-config-sample.php
sed -i "s|password_here|$dbpass|g" $path/wp-config-sample.php

mv $path/wp-config-sample.php $path/wp-config.php

# some very basic "security" and cleaning:
chmod 000 $path/xmlrpc.php
rm -f $path/readme.html
rm -f $path/lic*.txt # license.txt, licencia.txt...
