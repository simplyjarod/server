#!/bin/bash

# si no hay parametros en la llamada los pedimos por pantalla:
if [ -z $2 ]; then
	read -r -e -p "User name where Moodle will be installed (/home/user_name/public_html and /home/user_name/moodledata): " user
	read -r -e -p "Set domain name (do not write http://) (e.g. domain.com): " domain
	domain=${domain,,} # tolower
else
	user=$1
	domain=$2
fi

path="/home/$user/public_html"

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
	read -r -p "$path does not exists. Create it? [Y/n]: " create_path
	create_path=${create_path,,} # tolower

	if [[ $create_path =~ ^(no|n)$ ]]; then
		exit 1
	else
		mkdir -p $path
	fi
fi

# To clone a repository, path has to be empty
if [ -n "$path" ]; then
	read -r -p "Path is not empty. Delete all the contents in $path? [N/y]: " remove_path
	remove_path=${remove_path,,} # tolower

	if [[ $remove_path =~ ^(yes|y)$ ]]; then
		rm -rf $path/*
	else
		echo "Nothing was removed"
		exit 1
	fi
fi


# Moodle installation:
git clone https://github.com/moodle/moodle.git $path

chown -R root $path # required by moodle to not be able to be writeable by the web server user
chmod -R 0755 $path

chown $user /home/$user

mkdir /home/$user/moodledata
chmod 0777 /home/$user/moodledata


echo "<?php  // Moodle configuration file
unset(\$CFG);
global \$CFG;
\$CFG = new stdClass();
\$CFG->dbtype    = 'mariadb';
\$CFG->dblibrary = 'native';
\$CFG->dbhost    = 'localhost';
\$CFG->dbname    = '$dbname';
\$CFG->dbuser    = '$dbuser';
\$CFG->dbpass    = '$dbpass';
\$CFG->prefix    = 'mdl_';
\$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => 3306,
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_general_ci',
);
\$CFG->wwwroot   = 'http://$domain';
\$CFG->dataroot  = '/home/$user/moodledata';
\$CFG->admin     = 'admin';
\$CFG->directorypermissions = 0777;
require_once(__DIR__ . '/lib/setup.php');
// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!" >> $path/config.php
