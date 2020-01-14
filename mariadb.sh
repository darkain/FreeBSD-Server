#!/bin/sh

pkg install -y mariadb104-server mariadb104-client galera rsync stunnel grc bash

LINE='mysql_enable="YES"'
FILE='/etc/rc.conf.local'
touch "$FILE"
grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

service mysql-server start

mysql -e "DROP DATABASE IF EXISTS test"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -e "DELETE FROM mysql.global_priv WHERE User=''"
mysql -e "DELETE FROM mysql.global_priv WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -e "FLUSH PRIVILEGES"
