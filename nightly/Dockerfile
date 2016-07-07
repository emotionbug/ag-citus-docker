FROM citusdata/citus:latest
MAINTAINER Citus Data https://citusdata.com

# switch to Citus nightly
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
    && curl -s https://install.citusdata.com/community-nightlies/deb.sh | bash \
    && apt-get install --only-upgrade -y postgresql-$PG_MAJOR-citus \
    && apt-get purge -y --auto-remove ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*
