#!/bin/bash
set -e # 스크립트 실패 시 실행을 종료

# /var/lib/mysql: 실제 데이터 파일이 저장되는 곳
# /var/run/mysqld: 실행 관련 임시파일이 저장되는 곳(서버의 소켓 파일 등), 재부팅 시 초기화
# /var/lib/mysql과 /var/run/mysqld를 만듦
mkdir -p /var/lib/mysql /var/run/mysqld
# 위 두 폴더의 소유권과 그룹을 mysql으로 변경
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
# /var/run/mysqld 디렉토리의 모든 권한을 모든 사용자에게 허용
chmod 777 /var/run/mysqld

# mysql: 데이터베이스의 데이터에 sql을 사용하여 접근 (실제 저장된 데이터베이스)
# mysqld: 데이터베이스 서버 자체를 실행하는 데 사용되는 주요 실행 파일
# mysqladmin: 데이터베이스 서버의 관리 유지보수를 위한 명령줄 도구 (서버 자체 운영)

mysqld --user=root & # root 사용자로 mysqld 서버를 백그라운드에서 실행(&)
# mysqld 가 시행되기 이전까지 대기
# mysqladmin ping: 데이터베이스에 핑을 전송, 데이터베이스가 준비된 경우 성공 응답 반환
# -hlocalhost: localhost에서 작동되는 데이터베이스 서버 접속
# -uroot: 루트 유저로 데이터베이스에 접속, 데이터베이스의 상태를 확인하기 위해서는 관리자 권한 필요
until [ mysqladmin ping -hlocalhost -uroot > /dev/null 2>&1 ]
do
    echo "Waiting for MariaDB to start..."
    sleep 1
done
echo "MariaDB Start" # mysql 실행

# mysql에 root 사용자로 접속하여 명령어를 실행
# -p${MYSQL_ROOT_PASSWORD}: root의 비밀번호
mysql -uroot -p${MYSQL_ROOT_PASSWORD} <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
CREATE DATABASE ${MYSQL_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
# ALTER USER눈 사용자의 속성을 변경. 해당 구문은 root 사용자의 비밀번호를 변경함
# FLUSH PRIVILEGES;
# 사용자 계정에 대한 변경사항(권한, 계정 속성 등)을 즉시 적용
# CREATE DATABASE ${MYSQL_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
# 데이터베이스 생성, 문자 집합으로 utf8mb4를 사용하고, 문자열 비교 시 대소문자를 무시하며 악센트를 고려함.
# CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# 서버 유저 생성. 모든 호스트에서 접근 가능한 유저를 생성하고, 비밀번호를 설정
# GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
# 위에서 생성한 유저에게 위에서 생성한 데이터베이스의 모든 테이블에 대해 모든 권한을 부여

# 위에서 root 권한으로 실행된 mysql을 종료
mysqladmin -uroot -p${MYSQL_ROOT_PASSWORD} shutdown
# mysql 사용자로 하여 mysql 서버 실행
exec mysqld --user=mysql
