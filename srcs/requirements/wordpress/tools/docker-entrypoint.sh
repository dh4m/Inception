#!/bin/bash

set -e

# wp-cli 실행 권한 부여
chmod +x /usr/local/bin/wp

# 만약 이미 wordpress가 설치되어 있을 경우 그냥 실행
if wp core is-installed --allow-root; then
	exec php-fpm7.4 -F
fi

# wordpress 설치
wp core download --version=6.4.2 --path=/var/www/html --allow-root \
&& wp config create \
    --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=${MYSQL_HOST}:${MYSQL_TCP_PORT} --allow-root \
&& wp config set FORCE_SSL_ADMIN true --raw --allow-root \
&& wp config set WP_HOME https://${DOMAIN_NAME}/ --allow-root \
&& wp config set WP_SITEURL https://${DOMAIN_NAME}/ --allow-root \
&& wp config set WP_MEMORY_LIMIT 128M --allow-root \
&& wp config set FS_METHOD direct --allow-root \
&& wp core install \
	--url=${DOMAIN_NAME} --title=${WORDPRESS_TITLE} --admin_user=${WORDPRESS_ADMIN_NAME} --admin_password=${WORDPRESS_ADMIN_PW} --admin_email=${WORDPRESS_ADMIN_EMAIL} --allow-root \
&& wp user create ${WORDPRESS_USER_NAME} ${WORDPRESS_USER_EMAIL} --user_pass=${WORDPRESS_USER_PW} --allow-root

# wordpress 폴더의 소유권 및 권한 설정
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# php-fpm(wordpress fastcgi 서버) 실행
exec php-fpm7.4 -F
