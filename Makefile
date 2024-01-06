
DOCKER_COMPOSE := docker compose

ifeq ($(shell uname), Darwin)
# macOS인 경우
	DATA_DIR := /Users/${USER}/docker-data
else
# Linux인 경우
	DATA_DIR := /home/$(USER)/data
endif

all: up

up:
	make makeDirs
	$(DOCKER_COMPOSE) -f srcs/docker-compose.yml up -d --build

down:
	$(DOCKER_COMPOSE) -f srcs/docker-compose.yml down

restart:
	$(DOCKER_COMPOSE) -f srcs/docker-compose.yml restart

stop:
	$(DOCKER_COMPOSE) -f srcs/docker-compose.yml stop

build:
	$(DOCKER_COMPOSE) -f srcs/docker-compose.yml build

clean:
	make down
	docker system prune -f --all

fclean:
	make clean
	docker builder prune -f
	sudo rm -rf $(DATA_DIR)
	docker volume rm $$(docker volume ls -q)
# $$는 $를 이스케이프하기 위한 것으로, 쉘에서 $를 쓴 것과 동일함

logs:
	$(DOCKER_COMPOSE) -f srcs/docker-compose.yml logs $(SERVICE)

bash:
	docker exec -it $(SERVICE) /bin/bash

show: 
	docker ps -a | tail -n +1; echo
	docker images | tail -n +1; echo
	docker network ls | tail -n +1; echo
	docker volume ls | tail -n +1; echo

makeDirs:
	mkdir -p $(DATA_DIR)/wordpress $(DATA_DIR)/mariadb > /dev/null 2>&1

.PHONY: all up down restart stop build clean fclean bash logs show makeDirs