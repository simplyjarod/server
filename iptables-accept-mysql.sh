#!/bin/bash

# Si no hay parametro se pide por pantalla:
if [ -z $1 ]
then
	read -r -p "IPv4 to add to Firewall to connect to MySQL remotely: " ip
else
	ip=$1
fi


# Se comprueba que es una IPv4 y se agrega a iptables:
if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
then

	for i in 1 2 3 4; do
		if [ $(echo "$ip" | cut -d. -f$i) -gt 255 ]; then
			echo -e "\e[91mThe introduced IP does not seem to be correct.\e[0m"
			exit 1
		fi
	done

	iptables -I INPUT -p tcp -s $ip --dport 3306 -j ACCEPT
	exit 0
else
	echo -e "\e[91mThe introduced IP does not seem to be correct.\e[0m"
	exit 1
fi
