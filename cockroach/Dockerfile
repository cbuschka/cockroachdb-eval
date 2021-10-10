FROM cockroachdb/cockroach:v21.1.10

USER root

RUN microdnf update -y \
	&& microdnf install shadow-utils -y \
	&& rm -rf /var/cache/yum \
	&& useradd -d /cockroach cockroach \
	&& chown cockroach.cockroach -R /cockroach

COPY gosu-1.14-amd64 /usr/local/bin/
RUN ln -s /usr/local/bin/gosu-1.14-amd64 /usr/local/bin/gosu && \
	chmod 755 /usr/local/bin/gosu-1.14-amd64
COPY /docker-entrypoint.sh /
COPY /docker-entrypoint.d /docker-entrypoint.d
RUN chmod 755 /docker-entrypoint.sh /docker-entrypoint.d/*.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
