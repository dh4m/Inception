# 데비안 bullseye이미지를 기반으로 함
FROM debian:bullseye-slim

ENV WORDPRESS_VERSION 6.3.1
ENV WORDPRESS_SHA1 052777aef40e7f627c63c8a26eefe37b843a44df

RUN apt-get update \
    && apt-get install -y curl unzip php-fpm php-mysql php-xml php-gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz && \
    echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - && \
    tar -xzf wordpress.tar.gz -C /etc/wordpress/ && \
    rm wordpress.tar.gz
