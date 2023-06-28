#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi


if ! [ -x "$(command -v iptables)" ]; then
	echo -e "\e[91mIptables is not installed. Please, install Iptables first an re-run this script again.\e[0m"
	exit 1
fi


# Si no hay parametro se pide por pantalla:
if [ -z $1 ]; then
	remote_ip="$(echo $SSH_CLIENT | cut -f1 -d" ")"
	if [ -z $remote_ip ]; then
		echo "Maybe your current IP address is:" $remote_ip
	fi
	read -r -e -p "IPv4 to add to Firewall to connect to port 3306 (* for all IPs): " ip
else
	ip=$1
fi


# All IPs are allowed to connect to port 3306
if [[ $ip = "*" ]]; then 
	echo "All IPs will be allowed to connect through port 3306"
	iptables -I INPUT -p tcp --dport 3306 -j ACCEPT
	service iptables save
	exit 0
fi


# IPv4 format check:
if ! [[ $ip =~ ^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])$ ]]; then
	echo -e "\e[91mThe introduced IP does not seem to be correct.\e[0m"
	exit 1
fi


iptables -I INPUT -p tcp -s $ip --dport 3306 -j ACCEPT

if [ -x "$(command -v yum)" ]; then
	service iptables save
elif [ -x "$(command -v apt-get)" ]; then
	/sbin/iptables-save > /etc/iptables/rules.v4
else
	echo -e "\e[91mUnsupported system. Iptables rules were not saved.\e[0m"
	exit 1
fi
