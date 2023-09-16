#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi


if [ -x "$(command -v apt-get)" ]; then
	apt install apache2 -y

	systemctl enable apache2

else

	echo -e "\e[91mUnsupported system. Please install apache manually.\e[0m"
	exit 1
fi


service apache2 restart
