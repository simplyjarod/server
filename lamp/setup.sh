#!/bin/bash

# ****************************************
# ***** SCRIPT DE SETUP DEL SERVIDOR *****
# ****************************************


#
# APACHE:
#
echo "***** INSTALACION APACHE *****"
yum install -y httpd
\cp httpd.conf /etc/httpd/conf/httpd.conf
# todo: borrar welcome.conf, configurar errores, .htaccess...
systemctl start httpd
systemctl enable httpd    # to be automatically started at boot time


#
# MARIADB:
#
echo "***** INSTALACION MARIADB *****"
yum install mariadb mariadb-server -y
yum install MySQL-python -y   # instala mysql module for python
# todo: /usr/bin/mysql_secure_installation
systemctl start mariadb
systemctl enable mariadb      # to be automatically started at boot time


#
# PHP y PHP-MYADMIN:
#
echo "***** INSTALACION PHP Y PHP-MYADMIN *****"
yum install -y php php-mysql   # instala php
\cp php.ini /etc/php.ini       # custom (\cp = cp+overwrite)

yum install phpmyadmin -y    # instala phpmyadmin
\cp phpMyAdmin.conf /etc/httpd/conf.d/phpMyAdmin.conf  #custom


#
# FTP: DO NOT USE FTP. USE SFTP INSTEAD.
#
#echo "***** INSTALACION FTP *****"
#yum install -y vsftpd
#systemctl start vsftpd
#systemctl enable vsftpd    # to be automatically started at boot time


#
# BASIC FILES:
#
echo "***** COPIADO DE FICHEROS BASICOS *****"
cp index.php /var/www/html/index.php


#
# RESTART:
#
echo "***** REINICIANDO SERVICIOS... *****"
systemctl restart httpd


echo "***** FINALIZADO!! TODO LISTO!! *****"
