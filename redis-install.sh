#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
  echo -e "\e[91mERROR: This script must be run as root\e[0m"
  exit 1
fi

os=$(grep ^ID= /etc/os-release | cut -d "=" -f 2)
os=${os,,} #tolower


######################################
echo "***** REDIS INSTALLATION *****"
######################################

if [[ $os =~ "centos" ]]; then # $os contains "centos"
  # TO DO

elif [[ $os =~ "ubuntu" ]]; then # $os contains "ubuntu"
	apt install redis-server -y

else
  echo -e "\e[91mOS not detected. Redis was not installed\e[0m"
  exit 1
fi

# Allow Redis to start via the system control utility
sed -E -i "s/^supervised no/supervised systemd/g" /etc/redis/redis.conf

systemctl restart redis
