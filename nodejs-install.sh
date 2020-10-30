#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
  echo -e "\e[91mERROR: This script must be run as root\e[0m"
  exit 1
fi


######################################
echo "***** NODEJS INSTALLATION *****"
######################################
yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -
yum install -y nodejs



if type -path "iptables" > /dev/null 2>&1; then
###########################################
echo "***** FIREWALL SETUP (port 80) *****"
###########################################

./iptables-accept-http.sh \*
fi
