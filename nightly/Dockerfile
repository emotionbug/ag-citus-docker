FROM citusdata/citus:latest
MAINTAINER Citus Data https://citusdata.com

# install citus nightly from packagecloud
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && curl -s -O \
       https://packagecloud.io/install/repositories/citusdata/community-nightlies/script.deb.sh \
    && chmod +x script.deb.sh \
    && ./script.deb.sh \
    && rm -f script.deb.sh \
    && apt-get install -y postgresql-9.5-citus \
    && apt-get purge -y --auto-remove ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*
