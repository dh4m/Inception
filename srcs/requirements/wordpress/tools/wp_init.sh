#!/bin/bash

# 설치된 php-fpm의 버전을 확인한다
PHP_FPM_EXEC=$(which php-fpm)

# php-fpm을 포그라운드 환경에서 실행시킨다
exec $PHP_FPM_EXEC -F