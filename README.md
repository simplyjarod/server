# server
CentOS server installations and configurations

## LEMP server: Linux + nginx + MySql + php
Run `lemp-install.sh` as **root** from the folder you have placed the file.

This script will execute:
1. nginx installation
2. mysql installation (or mariadb on CentOS 7)
3. mysql_secure_installation (interactive mode)
4. php installation (and some "basic" libraries and modules)
5. creation of new user and virtual host in nginx (interactive mode: the script will ask you for domain and username)
6. iptables rule addition for port 80 (http server)
