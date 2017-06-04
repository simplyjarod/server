#!/bin/bash

if [ -z $1 ]; then # no hay parametros en la llamada, los pedimos por pantalla:

	read -r -p "Name of DataBase to remove: " dbname
	read -r -p "Name of DB User to remove: " dbuser

elif [ $# -ne 2 ]; then # hay parametros, pero no hay 2
	echo "Usage: $0 dbname dbuser"
	exit 65 #bad args

else
	dbname=$1
	dbuser=$2
fi


Q1="DROP DATABASE IF EXISTS $dbname;" # same as DROP SCHEMA IF EXISTS $dbname
Q2="DROP USER '$dbuser'@'%';"
Q3="FLUSH PRIVILEGES;";
Q4="SELECT Host, Db, User FROM mysql.db WHERE User IN (SELECT User FROM mysql.user);"
SQL="${Q1}${Q2}${Q3}${Q4}"

echo "Se va a solicitar la clave del usuario root de mysql"
`which mysql` -uroot -p -e "$SQL"

echo "DB $dbname and user $dbuser removed"
