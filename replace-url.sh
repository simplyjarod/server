#!/bin/bash
# @version 2016-01-26

if [ -z $1 ]; then # no hay parametros en la llamada, los pedimos por pantalla:

	read -r -p "Old domain (do not write http or www) (e.g. domain.com): " oldDomain
	read -r -p "New domain (do not write http or www) (e.g. domain.com): " newDomain
	read -r -p "File to replace domains (will be saved as a copy): " file
	read -r -p "Do you want to use https on new domain? [y/N] " useHttps

	if [ $oldDomain == $newDomain ]; then
		echo -e "\e[91mSorry, you cannot set same name for old and new domain.\e[0m"
		exit 1
	fi

elif [ $# -ne 4 ]; then # hay parametros, pero no hay 4
	echo "Usage: $0 oldDomain newDomain file useHttps"
	exit 65 #bad args

else
	oldDomain=$1
	newDomain=$2
	file=$3
	useHttps=$4
fi

useHttps=${useHttps,,} #tolower
if [[ $useHttps =~ ^(yes|y)$ ]]
then
	http='https'
else
	http='http'
fi

# por algun motivo no cambia bien a https, deja http aunque cambia el dominio

# From https:
sed "s/https%3A%2F%2F$oldDomain/$http:%3A%2F%2F$newDomain/g" $file > $file-replaced
sed -i "s/https:\\\\\/\\\\\/$oldDomain/$http:\\\\\/\\\\\/$newDomain/g" $file-replaced
sed -i "s/https:\/\/$oldDomain/$http:\/\/$newDomain/g" $file-replaced

# From http:
sed -i "s/http%3A%2F%2F$oldDomain/$http:%3A%2F%2F$newDomain/g" $file-replaced
sed -i "s/http:\\\\\/\\\\\/$oldDomain/$http:\\\\\/\\\\\/$newDomain/g" $file-replaced
sed -i "s/http:\/\/$oldDomain/$http:\/\/$newDomain/g" $file-replaced

# From generic //:
sed -i "s/%2F%2F$oldDomain/%2F%2F$newDomain/g" $file-replaced
sed -i "s/\\\\\/\\\\\/$oldDomain/\\\\\/\\\\\/$newDomain/g" $file-replaced
sed -i "s/\/\/$oldDomain/\/\/$newDomain/g" $file-replaced

sed -i "s/www.$oldDomain/www.$newDomain/g" $file-replaced
# OJO!! aquí se colaría un https://www... si haces replace de https a http


echo "The following matches have not been replaced:"
cat $file-replaced | grep -o -P ".{0,12}$oldDomain.{0,12}" | sort | uniq | grep $oldDomain --color=auto
