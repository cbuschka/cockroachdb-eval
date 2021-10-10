TOP_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
COCKROACH_ROOT_PASSWORD = asdfasdf

start-cluster:	_start-cluster configure-cluster configure-root-user

_start-cluster:	_build-image
	@cd ${TOP_DIR} && \
	echo "Starting cluster nodes..." && \
	docker-compose up -d roach1 && \
	docker-compose exec roach1 bash -c " \
		while [ ! -f "/cockroach/certs/client.root.crt" ]; do \
			sleep 0.1; \
		done \
	" && \
	docker-compose up -d && \
	docker-compose exec roach1 bash -c " \
		if [ ! -f '/cockroach/data/init.done' ]; then \
			./cockroach init --host=roach1 --certs-dir=/cockroach/certs && \
			touch /cockroach/data/init.done; \
		fi && \
		chown -R -c cockroach.cockroach /cockroach \
	" && \
	docker-compose logs

_build-image:
	@cd ${TOP_DIR}/cockroach && \
	if [ ! -x "gosu-1.14-amd64" ]; then \
		wget https://github.com/tianon/gosu/releases/download/1.14/gosu-amd64 -O gosu-1.14-amd64 && \
		chmod 755 gosu-1.14-amd64; \
	fi && \
	cd ${TOP_DIR} && \
	docker-compose build

open-web-console:
	xdg-open http://localhost:8080/

exec-shell:
	docker-compose exec --user cockroach:cockroach roach1 bash

tail-logs:
	@cd ${TOP_DIR} && \
	docker-compose logs -f --tail=1000

configure-cluster:
	@cd ${TOP_DIR} && \
	docker-compose exec --user cockroach:cockroach roach1 ./cockroach sql --echo-sql --certs-dir=/cockroach/certs -e " \
		SET CLUSTER SETTING diagnostics.reporting.enabled = false; \
		SET CLUSTER SETTING diagnostics.reporting.enabled = false; \
		SET CLUSTER SETTING sql.metrics.statement_details.enabled = false \
	"

configure-root-user:
	@cd ${TOP_DIR} && \
	docker-compose exec --user cockroach:cockroach roach1 ./cockroach sql --echo-sql --certs-dir=/cockroach/certs -e " \
		alter user root with password '${COCKROACH_ROOT_PASSWORD}'; \
		grant admin to root \
	" && \
	echo "Login with root/${COCKROACH_ROOT_PASSWORD}"

open-sql-console:
	@cd ${TOP_DIR} && \
	docker-compose exec --user cockroach:cockroach ./cockroach roach1 sql --certs-dir=/cockroach/certs

connect-via-psql:
	@cd ${TOP_DIR}
	psql postgresql://root@localhost:26257

stop-cluster:
	@cd ${TOP_DIR} && \
	docker-compose down

destroy-cluster:
	@cd ${TOP_DIR} && \
	docker-compose down --rmi local -v --remove-orphans && \
	docker-compose rm --force --stop -v
