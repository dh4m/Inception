# 데비안 bullseye이미지를 기반으로 함
FROM debian:bullseye-slim

# 9000 포트 열기
EXPOSE 9000

WORKDIR /var/www/html

# apt를 사용하여 필요한 패키지 설치 및 캐시 제거
# /var/www/html폴더의 소유자와 그룹을 www-data로 변경
# www-data란 일반적으로 웹 서버 프로세스를 실행하는 데 사용되는 표준 소유자와 그룹 이름
RUN apt-get update \
    && apt-get install -y php7.4 php7.4-fpm php7.4-gd php7.4-json php7.4-mysql php7.4-curl php7.4-mbstring php7.4-intl php-imagick php7.4-xml php7.4-zip mariadb-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/www/html /run/php \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# 설정 파일 임시 복사
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
ADD https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp
COPY --chmod=755 ./tools/docker-entrypoint.sh /etc/docker-entrypoint.sh

# init 쉘 스크립트 실행
CMD ["/etc/docker-entrypoint.sh"]
