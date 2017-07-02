# server
CentOS 6 & CentOS 7 server installations and configurations

Please, download *all files* before executing any script. There are several dependencies between them. You can use:
```bash
wget https://github.com/simplyjarod/server/archive/master.zip
unzip master.zip
rm master.zip -f
cd server-master
```

## LEMP server: Linux + nginx + MySql + php
Run `./lemp-install.sh` as **root** from the folder you have placed the file.

This script will execute:
1. nginx installation
2. mysql installation (or mariadb on CentOS 7)
3. mysql_secure_installation (interactive mode)
4. php installation (and some "basic" libraries and modules)
5. creation of new user and virtual host in nginx (interactive mode: the script will ask you for domain and username)
6. iptables rule addition for port 80 (http server) only in case iptables is installed


## nginx: add virtual host
Run `./nginx-add-virtual-host.sh` as **root** from the folder you have placed the file.
It is mandatory to have nginx installed previously (you can run `./lemp-install.sh`).


## mysql: create and remove database and user
Run `./mysql-create-db-and-user.sh` from the folder you have placed the file. You will be asked for mysql's root password.
Run `./mysql-remove-db-and-user.sh` from the folder you have placed the file. You will be asked for mysql's root password.
It is mandatory to have mysql or maridb installed previously (you can run `./lemp-install.sh`).


## iptables: accept http and myslq connections
Run `./iptables-accept-http.sh` as **root** from the folder you have placed the file.
Run `./iptables-accept-mysql.sh` as **root** from the folder you have placed the file.
It is mandatory to have iptables installed previously (you can run [iptables.sh from my system repository] (https://github.com/simplyjarod/system/blob/master/iptables.sh)).
