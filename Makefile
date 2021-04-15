.PHONY: run/script run/interactive db/start db/stop db/remove
.DEFAULT_GOAL := help

NAMESPACE := tomdewildt
NAME := foundations-of-databases

DB_HOST := 127.0.0.1
DB_PORT := 5432
DB_USER := postgres
DB_PASSWORD := postgres
DB_NAME := postgres
DB_VERSION := latest

SCRIPT := exercises-window

help: ## Show this help
	@echo "${NAMESPACE}/${NAME}"
	@echo
	@fgrep -h "##" $(MAKEFILE_LIST) | \
	fgrep -v fgrep | sed -e 's/## */##/' | column -t -s##

##

run/script: ## Run the script
	psql --host ${DB_HOST} --port ${DB_PORT} --username ${DB_USER} --file scripts/${SCRIPT}.sql

run/interactive: ## Run interactive mode
	psql --host ${DB_HOST} --port ${DB_PORT} --username ${DB_USER}

##

db/start: ## Start the database
	$(eval ID := $(shell docker ps -q -a --filter "name=${NAMESPACE}-${NAME}-db"))

	@if [ -z "${ID}" ]; then \
		docker run \
			--detach \
			--name ${NAMESPACE}-${NAME}-db \
			--publish ${DB_PORT}:5432 \
			--env POSTGRES_USER=${DB_USER} \
			--env POSTGRES_PASSWORD=${DB_PASSWORD} \
			--env POSTGRES_DB=${DB_NAME} \
			postgres:${DB_VERSION}; \
	else \
		docker start ${NAMESPACE}-${NAME}-db; \
	fi

db/stop: ## Stop the database
	docker stop ${NAMESPACE}-${NAME}-db

db/remove: ## Remove the database
	docker rm ${NAMESPACE}-${NAME}-db
	