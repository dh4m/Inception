#!/bin/bash

set -e

mkdir -p /var/lib/mysql /var/run/mysqld

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
chmod 777 /var/run/mysqld

mysqld --user=root &
until [ mysqladmin ping -hlocalhost -uroot > /dev/null 2>&1 ]
do
    echo "Waiting for MariaDB to start..."
    sleep 1
done

mysql -uroot -p${MYSQL_ROOT_PASSWORD} <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
CREATE DATABASE ${MYSQL_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysqladmin -uroot -p${MYSQL_ROOT_PASSWORD} shutdown

exec mysqld --user=mysql
