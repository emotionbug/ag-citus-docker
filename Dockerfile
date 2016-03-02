FROM postgres:9.5
MAINTAINER Citus Data https://citusdata.com

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget \
	&& wget -O /tmp/citus.deb -SL 'https://packages.citusdata.com/citus_5.0.0~rc.2-1_amd64.deb' \
    && dpkg --install /tmp/citus.deb \
    && rm /tmp/citus*.deb \
    && apt-get purge -y --auto-remove ca-certificates wget \
    && rm -rf /var/lib/apt/lists/*

COPY 000-add-citus-to-preload-libs.sql \
     001-restart-to-load-libs.sh \
     002-create-citus-extension.sql \
     /docker-entrypoint-initdb.d/

VOLUME /etc/citus
