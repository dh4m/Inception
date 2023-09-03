# 데비안 bullseye이미지를 기반으로 함
FROM debian:bullseye-slim

# 데비안이 설치 과정 중 사용자의 입력을 요구하는 프롬프트를 띄우지 않도록 함
ENV DEBIAN_FRONTEND=non-interactive

# apt로 nginx와 openssl을 설치한 이후 임시 파일들 삭제 및 openssl을 사용한 인증서 생성
RUN apt-get update \
    && apt-get install -y nginx openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/C=KR/ST=Seoul/O=42Seoul/CN=dham.42.fr" \
    -keyout /etc/nginx/ssl/my_inception_nginx.key \
    -out /etc/nginx/ssl/my_inception_nginx.crt
# req -x509: x509형식의 자체 서명된 인증서를 생성
# -nodes: 암호 없이 개인 키를 생성, 이게 있어야 암호 입력 없이 자동으로 키를 생성 가능함
# days 365: 인증서의 유효 기간을 365일로 설정
# -newkey rsa:2048: RSA알고리즘으로 2048비트의 키를 생성
# -subj "/C=KR/ST=Seoul/O=42Seoul/CN=dham.42.fr": 한국 서울의 42서울에서 생성한 인증서이며 dhan.42.fr도메인에 적용됨
# -keyout /etc/ssl/private/nginx-selfsigned.key: 키를 해당 경로에 저장
# -out /etc/nginx/ssl/my_inception_nginx.crt: 인증서를 해당 경로에 저장

# 설정 파일 복사
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# 443 포트 엶
EXPOSE 443

# nginx를 포어그라운드에서 실행, 이를 통해 컨테이너가 nginx가 실행되는 동안 종료되지 않음
CMD ["nginx", "-g", "daemon off;"]
