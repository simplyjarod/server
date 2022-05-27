#!/bin/bash

# More info: https://github.com/nodesource/distributions

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
  echo -e "\e[91mERROR: This script must be run as root\e[0m"
  exit 1
fi

os=$(grep ^ID= /etc/os-release | cut -d "=" -f 2)
os=${os,,} #tolower


######################################
echo "***** NODEJS INSTALLATION *****"
######################################

if [[ $os =~ "centos" ]]; then # $os contains "centos"
  yum install -y gcc-c++ make
  curl -sL https://rpm.nodesource.com/setup_lts.x | sudo -E bash -
  yum install -y nodejs

elif [[ $os =~ "ubuntu" ]]; then # $os contains "ubuntu"
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
	apt-get install -y nodejs

else
  echo -e "\e[91mOS not detected. NodeJS was not installed\e[0m"
  exit 1
fi


if type -path "iptables" > /dev/null 2>&1; then
###########################################
echo "***** FIREWALL SETUP (port 80) *****"
###########################################

./iptables-accept-http.sh \*
fi
