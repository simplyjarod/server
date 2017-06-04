#|/bin/bash

# ADD MONGODB YUM REPOSITORY:
echo "[MongoDB]" >> /etc/yum.repos.d/mongodb.repo
echo "name=MongoDB Repository" >> /etc/yum.repos.d/mongodb.repo
echo "baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/" >> /etc/yum.repos.d/mongodb.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/mongodb.repo
echo "enabled=1" >> /etc/yum.repos.d/mongodb.repo


# INSTALL MONGODB SERVER:
yum install mongo-10gen mongo-10gen-server -y


# START MONGODB:
service mongod start

chkconfig mongod on


# ready to play with:
# ...$ mongo


# PHP DRIVER: (not very well tested beyond this point)
yum install gcc php-pear php-devel php-pecl-mongo

pecl install mongo #hit enter here (thus answering 'no')

echo "extension=mongo.so" > /etc/php.d/mongo.ini

# creo que solo es necesario reiniciar uno de los dos (php seguramente)
service nginx restart
service php-fpm restart

