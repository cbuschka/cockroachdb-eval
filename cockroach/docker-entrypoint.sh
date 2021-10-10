#!/bin/sh

set -eu

for script in /docker-entrypoint.d/*; do
  cd /cockroach
  ${script}
done

if [ "${1-}" = "root-shell" ]; then
  shift
  exec /bin/sh "$@"
else
  exec /usr/local/bin/gosu cockroach /cockroach/cockroach.sh "$@"
fi
