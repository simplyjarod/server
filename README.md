# CentOS 6 & 7 server installation and configuration

Please, **download _all files_ before executing any script**. There are several dependencies between them. You can use:
```bash
wget https://github.com/simplyjarod/server/archive/master.zip
unzip master.zip
cd server-master
```

## LAMP server: Linux + apache + MySQL + php
Run `./lamp-install.sh` as **root** from the folder this file is placed.


## LEMP server: Linux + nginx + MySQL + php
Run `./lemp-install.sh` as **root** from the folder this file is placed.

This script will execute:
1. nginx installation
2. mysql installation (or mariadb on CentOS 7)
3. mysql_secure_installation (interactive mode)
4. php installation (and some "basic" libraries and modules)
5. creation of new user and virtual host in nginx (interactive mode: the script will ask you for domain and username)
6. iptables rule addition for port 80 (http server) only in case iptables is installed


## nginx: add virtual host
Run `./nginx-add-virtual-host.sh` as **root** from the folder this file is placed.  
It is mandatory to have nginx installed previously.


## mysql: create and remove database and user
Run `./mysql-create-db-and-user.sh` from the folder this file is placed. You will be asked for **mysql's root password**.  
Run `./mysql-remove-db-and-user.sh` from the folder this file is placed. You will be asked for **mysql's root password**.  
It is mandatory to have mysql or maridb installed previously.


## iptables: accept http and mysql connections
Run `./iptables-accept-http.sh` as **root** from the folder this file is placed.  
Run `./iptables-accept-mysql.sh` as **root** from the folder this file is placed.  
It is mandatory to have iptables installed previously (you can run [iptables.sh from my system repository](https://github.com/simplyjarod/system/blob/master/iptables.sh)).
