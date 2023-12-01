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
	apt-get install -y ca-certificates curl gnupg
	mkdir -p /etc/apt/keyrings
	curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
	NODE_MAJOR=20 # can be changed depending on the version you need
	apt-get update
	apt-get install nodejs -y

	# To uninstall:
	# apt-get purge nodejs
	# rm -r /etc/apt/sources.list.d/nodesource.list
	# rm -r /etc/apt/keyrings/nodesource.gpg

else
	echo -e "\e[91mUnsupported system. Please install NodeJS manually.\e[0m"
	exit 1
fi


###################################
echo "***** PM2 INSTALLATION *****"
###################################
npm install pm2@latest -g
