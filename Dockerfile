FROM postgres:11.11
ARG VERSION=10.0.3

ENV CITUS_VERSION ${VERSION}.citus-1

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
  bison \
  build-essential \
  ca-certificates \
  flex \
  git \
  postgresql-plpython3-11 \
  postgresql-server-dev-11 \
  curl

RUN git clone https://github.com/apache/incubator-age /age \
  && cd /age && make install

# install Citus
RUN curl -s https://install.citusdata.com/community/deb.sh | bash \
    && apt-get install -y postgresql-$PG_MAJOR-citus-10.0.=$CITUS_VERSION \
                          postgresql-$PG_MAJOR-hll=2.15.citus-1 \
                          postgresql-$PG_MAJOR-topn=2.3.1 \
    && apt-get purge -y --auto-remove curl \
    && rm -rf /var/lib/apt/lists/*

# add citus to default PostgreSQL config
RUN echo "shared_preload_libraries='citus,age'" >> /usr/share/postgresql/postgresql.conf.sample

# add scripts to run after initdb
COPY 001-create-age-extension.sql /docker-entrypoint-initdb.d/
COPY 002-create-citus-extension.sql /docker-entrypoint-initdb.d/

# add health check script
COPY pg_healthcheck wait-for-manager.sh /
RUN chmod +x /wait-for-manager.sh

# entry point unsets PGPASSWORD, but we need it to connect to workers
# https://github.com/docker-library/postgres/blob/33bccfcaddd0679f55ee1028c012d26cd196537d/12/docker-entrypoint.sh#L303
RUN sed "/unset PGPASSWORD/d" -i /usr/local/bin/docker-entrypoint.sh

HEALTHCHECK --interval=4s --start-period=6s CMD ./pg_healthcheck
