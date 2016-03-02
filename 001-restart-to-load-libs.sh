#!/bin/bash

# make bash behave
set -euo pipefail
IFS=$'\n\t'

# constants
workerlist=pg_worker_list.conf
citusconfdir=/etc/citus
externalworkerlist="$citusconfdir/$workerlist"

touch "$externalworkerlist"
chown postgres:postgres "$externalworkerlist"
gosu postgres ln -s "$externalworkerlist" "$PGDATA/$workerlist"

gosu postgres pg_ctl -D "$PGDATA" -m fast -w restart
