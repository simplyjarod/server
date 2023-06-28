#!/bin/bash

# ARE YOU ROOT (or sudo)?
if [[ $EUID -ne 0 ]]; then
  echo -e "\e[91mERROR: This script must be run as root\e[0m"
  exit 1
fi


######################################
echo "***** REDIS INSTALLATION *****"
######################################

if [ -x "$(command -v apt-get)" ]; then
	apt-get install redis-server -y
else
  echo -e "\e[91mUnsupported system. Please install redis manually.\e[0m"
  exit 1
fi

# Allow Redis to start via the system control utility
sed -E -i "s/^supervised no/supervised systemd/g" /etc/redis/redis.conf

systemctl restart redis
