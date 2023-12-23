#!/bin/bash

set -e

chmod +x /usr/local/bin/wp

wp core download --version=6.4.2 --path=/var/www/html --allow-root \
&& wp config create \
    --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=${MYSQL_HOST} --allow-root \
&& wp core install \
	--url=${DOMAIN_NAME} --title=${WORDPRESS_TITLE} --admin_user=${WORDPRESS_ADMIN_NAME} --admin_password=${WORDPRESS_ADMIN_PW} --admin_email=${WORDPRESS_ADMIN_EMAIL} --allow-root \
&& wp user create ${WORDPRESS_USER_NAME} ${WORDPRESS_USER_EMAIL} --user_pass=${WORDPRESS_USER_PW} --allow-root

exec php-fpm7.4 -F
