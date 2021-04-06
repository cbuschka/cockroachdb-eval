TOP_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

start-cluster:
	@cd ${TOP_DIR} && \
	docker-compose up -d

tail-logs:
	@cd ${TOP_DIR} && \
	docker-compose logs

init-cluster:
	@cd ${TOP_DIR} && \
	docker-compose exec roach1 ./cockroach init --insecure

connect:
	@cd ${TOP_DIR} && \
	psql postgresql://root@localhost:26257?sslmode=disable

stop-cluster:
	@cd ${TOP_DIR} && \
	docker-compose down

destroy-cluster:
	@cd ${TOP_DIR} && \
	docker-compose down --rmi local -v --remove-orphans && \
	docker-compose rm --force --stop -v

