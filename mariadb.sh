#!/bin/sh

mkdir /mysql
ln -s /mysql /var/db/mysql

# INSTALL THE PACKAGES
pkg install -y mariadb1011-server mariadb1011-client galera26 rsync stunnel grc bash

# CLEAN UP PERMISSIONS
chown -R mysql:mysql /mysql
chown mysql:mysql /var/db/mysql

# ENABLE AND START THE SERVICE
sysrc mysql_enable="YES"
service mysql-server start

# CLEANUP DEFAULT CRUFT
mysql -e "DROP DATABASE IF EXISTS test"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -e "DELETE FROM mysql.global_priv WHERE User=''"
mysql -e "DELETE FROM mysql.global_priv WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -e "FLUSH PRIVILEGES"
