# 데비안 bullseye이미지를 기반으로 함
FROM debian:bullseye-slim

ENV WORDPRESS_VERSION 5.8
ENV WORDPRESS_SHA1 f05f425b7f961abfcd71022eeb2fdbf7

RUN apt-get update && \
    apt-get install -y curl unzip php-fpm php-mysql php-xml php-gd && \
    apt-get clean && rm -rf /var/lib/apt/lists/*