# 데비안 bullseye이미지를 기반으로 함
FROM debian:bullseye-slim

# apt로 mariadb와 dumb-init 을 설치
RUN apt-get update \
    && apt-get install -y mariadb-server dumb-init \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 설정 파일 복사
COPY ./conf/my.cnf /etc/mysql/my.cnf

# init 쉘 스크립트 복사
COPY ./tools/mariadb_init.sh /etc/mariadb_init.sh
# init 쉘 스크립트 실행 권한 부여
RUN chmod +x /etc/mariadb_init.sh

# 3306 포트를 엶
EXPOSE 3306

# dumb-init 을 사용하는 이유
# 도커는 기본적으로 PID1에서 단일 어플리케이션 프로세스를 실행시키나
# 단일 어플리케이션의 경우 시그널 처리, 자식 프로세스 관리 등을 제대로 수행할 수 없음
# 따라서 프로세스 관리 툴인 dumb-init을 실행하고 그 자식으로 어플리케이션을 실행함
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/etc/mariadb_init.sh"]