#!/bin/bash

LOCK_FILE=/cockroach/certs/certs.lock

_lock() {
  flock -x ${LOCK_FILE}
}

_unlock() {
  flock -u ${LOCK_FILE}
}

_lock
trap _unlock EXIT
if [ ! -f '/cockroach/certs/ca.key' ]; then 
	echo 'Generating certificate authority...'
	./cockroach cert create-ca --certs-dir=/cockroach/certs --ca-key=/cockroach/certs/ca.key
fi
if [ ! -f '/cockroach/certs/node.crt' ]; then
	echo 'Generating node certificate...'
	./cockroach cert create-node roach1 roach2 roach3 localhost --certs-dir=/cockroach/certs --ca-key=/cockroach/certs/ca.key
fi
if [ ! -f '/cockroach/certs/client.root.crt' ]; then
	echo 'Generating root client certificate...'
	./cockroach cert create-client root --certs-dir=/cockroach/certs --ca-key=/cockroach/certs/ca.key
fi

./cockroach cert list --certs-dir=/cockroach/certs

