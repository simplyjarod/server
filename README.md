# CentOS 6, 7, 8 and Ubuntu server installation and configuration

Please, **download _all files_ before executing any script**. There are several dependencies between them.

## CentOS
```bash
sudo yum install wget unzip -y
wget https://github.com/simplyjarod/server/archive/master.zip
unzip master.zip && cd server-master && rm -rf ../master.zip
chmod u+x *.sh -R
```

## Ubuntu
```bash
apt update -y && apt upgrade -y
apt install wget unzip -y
wget https://github.com/simplyjarod/server/archive/master.zip
unzip master.zip && cd server-master && rm -rf ../master.zip
chmod u+x *.sh -R
```


# What you can do with these scripts
*Elements with link are updated for Ubuntu compatibility.*
- Install LAMP server
- [Install LEMP server](#install-lemp-server-linux--nginx--mysql--php)
- [Install NGINX](#install-nginx)
- [Add NGINX virtual host](#add-nginx-virtual-host)
- [Manage HTTP traffic with IPTABLES](#manage-http-traffic-with-iptables)
- [Manage MySQL traffic with IPTABLES](#manage-mysql-traffic-with-iptables)
- Generate Let's Encrypt SSL certificates
- [Install PHP](#install-php)
- Update PHP to latest version
- [Install NodeJS, NPM and PM2](#install-nodejs-npm-and-pm2)
- [Install MariaDB](#install-mariadb)
- Install MongoDB
- [Create MySQL DB and user](#create-mysql-db-and-user)
- [Remove MySQL DB and user](#remove-mysql-db-and-user)
- Install REDIS
- [Install WordPress](#install-wordpress)


## Install LAMP server: Linux + apache + MySQL + php
Run `./lamp-install.sh` as **root** from the folder this file is placed.


## LEMP server: Linux + NGINX + MySQL + php
Run `./lemp-install.sh` as **root** from the folder this file is placed.
This will run the following scripts: [Install NGINX](#install-nginx), [Install MariaDB](#install-mariadb), [Install PHP](#install-php), [Add NGINX virtual host](#add-nginx-virtual-host) and [Manage HTTP traffic with IPTABLES](#manage-http-traffic-with-iptables).


## Install NGINX
Run `./nginx-install.sh` as **root** from the folder this file is placed.
This will install NGINX and some basic setup.


## Add NGINX virtual host
Run `./nginx-add-virtual-host.sh` as **root** from the folder this file is placed.  
It is mandatory to have NGINX installed previously.
This will create a new user (if not created previously) and virtual host in NGINX in interactive mode: the script will ask you for system username and domain.


## Manage HTTP traffic with IPTABLES 
Run `./iptables-accept-http.sh` as **root** from the folder this file is placed.  
It is mandatory to have IPTABLES installed previously (you can run [iptables.sh from my system repository](https://github.com/simplyjarod/system/blob/master/iptables.sh)).
This will insert into IPTABLES a new rule for port 80 (HTTP traffic) binded to an IP or to all IPs (unrestricted).


## Manage MySQL traffic with IPTABLES 
Run `./iptables-accept-mysql.sh` as **root** from the folder this file is placed.  
It is mandatory to have IPTABLES installed previously (you can run [iptables.sh from my system repository](https://github.com/simplyjarod/system/blob/master/iptables.sh)).
This will insert into IPTABLES a new rule for port 3306 (MySQL traffic) binded to an IP or to all IPs (unrestricted).


## Install PHP
Run `./php-install.sh` as **root** from the folder this file is placed.
This will install PHP latest available version. In CentOS, PHP is not available on latest version, so `php-update.sh` is executed right after the default installation. Some "basic" libraries and modules are also installed.


## Install NodeJS, NPM and PM2
Run `./nodejs-install.sh` as **root** from the folder this file is placed.
This will install NodeJS and NPM latest LTS version directly from nodesource.com.


## Install MariaDB
Run `./mariadb-install.sh` as **root** from the folder this file is placed.
This will install MariaDB (MySQL), mysql_secure_installation (interactive mode) and some basic setup.


## Create MySQL DB and user
Run `./mysql-create-db-and-user.sh` from the folder this file is placed. You will be asked for **mysql's root password**.  
It is mandatory to have MySQL or MariaDB installed previously.


## Remove MySQL DB and user
Run `./mysql-remove-db-and-user.sh` from the folder this file is placed. You will be asked for **mysql's root password**.  
It is mandatory to have MySQL or MariaDB installed previously.


## Install WordPress
Run `./wordpress-install.sh` as **root** from the folder this file is placed.
This will download a new WordPress copy and install it in the folder you specify, creating and configuring a new database, user and password (random names or the ones you provide).