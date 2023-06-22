#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[91mERROR: This script must be run as root\e[0m"
	exit 1
fi

# Operative System:
os=$(grep ^ID= /etc/os-release | cut -d "=" -f 2)
os=${os,,} #tolower


# Si no hay parametro se pide por pantalla:
if [ -z $1 ]; then
	remote_ip="$(echo $SSH_CLIENT | cut -f1 -d" ")"
	if [ -z $remote_ip ]; then
		echo "Maybe your current IP address is:" $remote_ip
	fi
	read -r -p "IPv4 to add to Firewall to connect to port 80 (* for all IPs): " ip
else
	ip=$1
fi


# All IPs are allowed to connect to port 80
if [[ $ip = "*" ]]; then
        echo "All IPs will be allowed to connect through port 80"
	iptables -I INPUT -p tcp --dport 80 -j ACCEPT
	service iptables save
	exit 0
fi


# IPv4 check:
if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then

	for i in 1 2 3 4; do
		if [ $(echo "$ip" | cut -d. -f$i) -gt 255 ]; then
			echo -e "\e[91mThe introduced IP does not seem to be correct.\e[0m"
			exit 1
		fi
	done

	iptables -I INPUT -p tcp -s $ip --dport 80 -j ACCEPT

	if [[ $os =~ "centos" ]]; then # $os contains "centos"
		service iptables save
	elif [[ $os =~ "ubuntu" ]]; then # $os contains "ubuntu"
		/sbin/iptables-save > /etc/iptables/rules.v4
	else
		echo -e "\e[91mOS not detected. Iptables rules were not saved.\e[0m"
		exit 1
	fi
	exit 0
else
	echo -e "\e[91mThe introduced IP does not seem to be correct.\e[0m"
	exit 1
fi
