#!/bin/bash

DOCKER_BE = sf5-videos-api-be
UID = $(shell id -u)

ifeq ($(OS),Darwin)
	UID = $(shell id -u)
else ifeq ($(OS),Linux)
	UID = $(shell id -u)
else
	UID = 1000
endif

help: ## Show this help message
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

run: ## Start the containers
ifeq ($(OS),Darwin)
	docker volume create --name=sf5-videos-api-be-sync
	U_ID=${UID} docker-compose -f docker-compose.macos.yml up -d
	U_ID=${UID} docker-sync start
else
	U_ID=${UID} docker-compose -f docker-compose.linux.yml up -d
endif

stop: ## Stop the containers
ifeq ($(OS),Darwin)
	U_ID=${UID} docker-compose -f docker-compose.macos.yml stop
	U_ID=${UID} docker-sync stop
else
	U_ID=${UID} docker-compose -f docker-compose.linux.yml stop
endif

docker-sync-restart: ## Rebuild docker-sync stack and prepare environment
	U_ID=${UID} docker-sync-stack clean
	$(MAKE) run
	$(MAKE) prepare

restart: ## Restart the containers
	$(MAKE) stop && $(MAKE) run

build: ## Rebuilds all the containers
ifeq ($(OS),Darwin)
	U_ID=${UID} docker-compose -f docker-compose.macos.yml build --compress --parallel
else
	U_ID=${UID} docker-compose -f docker-compose.linux.yml build
endif

prepare: ## Runs backend commands
	$(MAKE) be-sf-permissions
	$(MAKE) composer-install
	$(MAKE) migrations

# Backend commands
be-sf-permissions: ## Configure the Symfony permissions
	U_ID=${UID} docker exec -it -uroot ${DOCKER_BE} sh /usr/bin/sf-permissions

composer-install: ## Installs composer dependencies
	U_ID=${UID} docker exec --user ${UID} -it ${DOCKER_BE} composer install --no-scripts --no-interaction --optimize-autoloader

migrations: ## Runs the migrations
	U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} bin/console doctrine:migrations:migrate -n

cache: ## Clear SF cache
	U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} bin/console cache:clear

be-logs: ## Tails the Symfony dev log
	U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} tail -f var/log/dev.log
# End backend commands

ssh-be: ## ssh's into the be container
	U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} bash

ssh-db: ##
	docker exec -it sf5-videos-api-db mysql -uroot -proot  bash




