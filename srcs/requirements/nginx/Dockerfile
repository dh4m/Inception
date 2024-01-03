# 데비안 bullseye이미지를 기반으로 함
FROM debian:bullseye-slim

# apt로 nginx와 openssl을 설치한 이후 임시 파일들 삭제
# nginx의 로그 파일을 표준 출력 및 표준 에러 출력으로 리다이렉트
RUN apt-get update; \
    apt-get install -y nginx openssl curl; \
    apt-get clean; rm -rf /var/lib/apt/lists/*; \
    mkdir -p /etc/nginx/ssl; \
    ln -sf /dev/stdout /var/log/nginx/access.log; \
    ln -sf /dev/stderr /var/log/nginx/error.log;

# 설정 파일 복사
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# init 쉘 스크립트 복사, 실행 권한 부여
COPY --chmod=755 ./tools/docker-entrypoint.sh /etc/docker-entrypoint.sh

# 443 포트 열기
EXPOSE 443

# init 쉘 스크립트 실행
CMD ["/etc/docker-entrypoint.sh"]
