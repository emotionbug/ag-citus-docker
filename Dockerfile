FROM postgres:9.5.3
MAINTAINER Citus Data https://citusdata.com

ENV CITUS_VERSION 5.1.0-1.pgdg80+1

# install Citus
RUN apt-get update \
    && apt-get install -y postgresql-$PG_MAJOR-citus=$CITUS_VERSION \
    && rm -rf /var/lib/apt/lists/*

# add citus to default PostgreSQL config
RUN echo "shared_preload_libraries='citus'" >> /usr/share/postgresql/postgresql.conf.sample

# add scripts to run after initdb
COPY 000-symlink-workerlist.sh 001-create-citus-extension.sql /docker-entrypoint-initdb.d/

# expose workerlist via volume
VOLUME /etc/citus
