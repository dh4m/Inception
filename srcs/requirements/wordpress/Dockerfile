# 데비안 bullseye이미지를 기반으로 함
FROM debian:bullseye-slim

# 9000 포트 열기
EXPOSE 9000

# wordpress 버전 6.3.1(latest) 사용 및 해당 버전의 sha1
ENV WORDPRESS_VERSION 6.3.1
ENV WORDPRESS_SHA1 052777aef40e7f627c63c8a26eefe37b843a44df

# apt를 사용하여 필요한 패키지 설치
RUN apt-get update \
    && apt-get install -y curl unzip php-fpm php-mysql php-xml php-gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# curl 명령어를 통해 wordpress 압축 파일을 다운받고 sha로 검증한 후 압축을 풀어 설치
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
    && echo "$WORDPRESS_SHA1 wordpress.tar.gz" | sha1sum -c - \
    && tar -xzf wordpress.tar.gz -C /etc/wordpress/ \
    && rm wordpress.tar.gz \
    && mkdir -p /var/www/html

# /var/www/html폴더의 소유자와 그룹을 www-data로 변경, 
# www-data란 일반적으로 웹 서버 프로세스를 실행하는 데 사용되는 표준 소유자와 그룹 이름
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# 설정 파일 임시 복사
COPY ./conf/www.conf /tmp/config/www.conf

# 설정 파일 복사
RUN cp /tmp/config/www.conf /etc/php/7.4/fpm/pool.d/www.conf \
    && rm -rf /tmp/config/www.conf

# init 쉘 스크립트 실행
CMD ["php-fpm -F"]
