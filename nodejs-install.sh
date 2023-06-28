#!/bin/bash

# More info: https://github.com/nodesource/distributions

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi


######################################
echo "***** NODEJS INSTALLATION *****"
######################################

if [ -x "$(command -v yum)" ]; then
	yum install -y gcc-c++ make
	curl -sL https://rpm.nodesource.com/setup_lts.x | sudo -E bash -
	yum install -y nodejs

elif [ -x "$(command -v apt-get)" ]; then
	curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
	apt-get install -y nodejs

else
	echo -e "\e[91mUnsupported system. Please install NodeJS manually.\e[0m"
	exit 1
fi


###################################
echo "***** PM2 INSTALLATION *****"
###################################
npm install pm2@latest -g
