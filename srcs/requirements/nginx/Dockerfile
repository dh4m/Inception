# 데비안 bullseye이미지를 기반으로 함
FROM debian:bullseye-slim

# 데비안이 설치 과정 중 사용자의 입력을 요구하는 프롬프트를 띄우지 않도록 함
ENV DEBIAN_FRONTEND=non-interactive

# apt로 nginx와 openssl을 설치한 이후 임시 파일들 삭제
RUN apt-get update \
    && apt-get install -y nginx openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/nginx/ssl

# 설정 파일 복사
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# init 쉘 스크립트 복사
COPY ./tools/nginx_init.sh /etc/nginx_init.sh
# init 쉘 스크립트 실행 권한 부여
RUN chmod +x /etc/nginx_init.sh

# 443 포트 열기
EXPOSE 443

# init 쉘 스크립트 실행
CMD ["/etc/nginx_init.sh"]
