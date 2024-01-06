# 데비안 bullseye이미지를 기반으로 함
FROM debian:bullseye-slim

# apt로 mariadb와 dumb-init 을 설치 및 폴더 생성
# /var/lib/mysql: 실제 데이터 파일이 저장되는 곳
# /var/run/mysqld: 실행 관련 임시파일이 저장되는 곳(서버의 소켓 파일 등), 재부팅 시 초기화
RUN apt-get update; \
    apt-get install -y mariadb-server dumb-init; \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
    mkdir -p /var/lib/mysql /var/run/mysqld;

# 설정 파일 복사
COPY ./conf/my.cnf /etc/mysql/my.cnf
# init 쉘 스크립트 복사 후 실행 권한 부여
COPY --chmod=755 ./tools/docker-entrypoint.sh /etc/docker-entrypoint.sh

# 3306 포트를 엶
EXPOSE 3306

# dumb-init 을 사용하는 이유
# 도커는 기본적으로 PID1에서 단일 어플리케이션 프로세스를 실행시키나
# 단일 어플리케이션의 경우 시그널 처리, 자식 프로세스 관리 등을 제대로 수행할 수 없음
# 따라서 프로세스 관리 툴인 dumb-init을 실행하고 그 자식으로 어플리케이션을 실행함
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/etc/docker-entrypoint.sh"]