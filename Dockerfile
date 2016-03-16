FROM postgres:9.5.1
MAINTAINER Citus Data https://citusdata.com

# install Citus
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget \
	&& wget -O /tmp/citus.deb -SL 'https://s3.amazonaws.com/packages.citusdata.com/debian/jessie/postgresql-9.5-citus_5.0.0-1_amd64.deb' \
    && dpkg --install /tmp/citus.deb \
    && rm /tmp/citus*.deb \
    && apt-get purge -y --auto-remove ca-certificates wget \
    && rm -rf /var/lib/apt/lists/*

# add citus to default PostgreSQL config
RUN echo "shared_preload_libraries='citus'" >> /usr/share/postgresql/postgresql.conf.sample

# add scripts to run after initdb
COPY 000-symlink-workerlist.sh 001-create-citus-extension.sql /docker-entrypoint-initdb.d/

# expose workerlist via volume
VOLUME /etc/citus
