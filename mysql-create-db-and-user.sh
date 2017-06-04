#!/bin/bash

if [ -z $1 ]; then # no hay parametros en la llamada, los pedimos por pantalla:

	read -r -p "Name of new DataBase: " dbname
	read -r -p "Name of new DB User: " dbuser
	read -s -p "New password for DB User $dbuser: " dbpass
	echo "" # we need a new line after the password
	read -s -p "Retype new password for user $dbuser: " dbpass2
	echo "" # we need a new line after the password

	if [ $dbpass != $dbpass2 ]; then
		echo -e "\e[91mSorry, passwords do not match.\e[0m"
		exit 1
	fi

elif [ $# -ne 3 ]; then # hay parametros, pero no hay 3
	echo "Usage: $0 dbname dbuser dbpass"
	exit 65 #bad args

else
	dbname=$1
	dbuser=$2
	dbpass=$3
fi


Q1="CREATE DATABASE IF NOT EXISTS $dbname;"
Q2="GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'%' IDENTIFIED BY '$dbpass';"
Q3="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}"

echo "Please, type MySQL's root password:"
`which mysql` -uroot -p -e "$SQL"

echo "DB $dbname created with all privileges granted to DB user $dbuser"
