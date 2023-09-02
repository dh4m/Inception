FROM alpine:latest

RUN apk --no-cache nginx

RUN apk --no-cache openssl
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/C=KR/ST=Seoul/O=42Seoul/CN=dham.42.fr" \
    -keyout /etc/nginx/ssl/my_inception_nginx.key \
    -out /etc/nginx/ssl/my_inception_nginx.crt

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
