FROM bitnine/agensgraph:v2.1.3-debian
ARG VERSION=8.3.2

ENV CITUS_VERSION ${VERSION}.citus-1

# install Citus
RUN apt-get update \
    && build_deps='build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt1-dev libssl-dev libxml2-utils xsltproc pkg-config uuid-dev' \
    && apt-get install -y $build_deps git libcurl4-openssl-dev pax-utils \
    && git clone git clone https://github.com/citusdata/citus.git \
    && git checkout release-8.3 \
    && cd /citus/citus \
    && ./configure \
    && make install \
    && apt-get purge -y --auto-remove curl \
    && rm -rf /var/lib/apt/lists/*

# add citus to default PostgreSQL config
RUN echo "shared_preload_libraries='citus'" >> /usr/local/share/postgresql/postgresql.conf.sample

# add scripts to run after initdb
COPY 000-configure-stats.sh 001-create-citus-extension.sql /docker-entrypoint-initdb.d/

# add health check script
COPY pg_healthcheck /

HEALTHCHECK --interval=4s --start-period=6s CMD ./pg_healthcheck
