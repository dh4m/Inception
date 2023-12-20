#!/bin/bash
set -e # 스크립트 실패 시 실행을 종료

mysqld --defaults-file=/etc/mysql/my.cnf --bootstrap --verbose <<EOF
FLUSH PRIVILEGES;
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

# mysqld: 데이터베이스 서버 자체를 실행하는 데 사용되는 주요 실행 파일
# mysqld --initialize: 초기화 작업 수행, 이 경우 init-file을 초기화 마무리 시 수행

# mysql 사용자로 하여 mysql 서버 실행
exec mysqld --user=mysql
