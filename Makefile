TOP_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

start-cluster:
	@cd ${TOP_DIR} && \
	docker-compose up -d

tail-logs:
	@cd ${TOP_DIR} && \
	docker-compose logs
