# Builder for pg_repack extension
ARG DISTRO
ARG CNPG_TAG

FROM debian:${DISTRO}-slim AS builder

ARG CNPG_TAG
ARG PG_REPACK_TAG

RUN set -xe ;\
    apt update && apt install wget lsb-release gnupg2 -y ;\
    sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' ;\
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - ;\
    apt-get update ;\
    apt-get install --no-install-recommends -y postgresql-server-dev-${CNPG_TAG%.*} checkinstall build-essential git liblz4-dev libreadline-dev zlib1g-dev libzstd-dev; \
    cd /tmp; \
    git clone --depth=1 --branch ver_${PG_REPACK_TAG} https://github.com/reorg/pg_repack; \
    cd /tmp/pg_repack; \
    PG_CONFIG=/usr/lib/postgresql/${CNPG_TAG%.*}/bin/pg_config make -j$(nproc); \
    checkinstall -D --install=no --fstrans=no --backup=no --pakdir=/tmp --pkgversion=${PG_REPACK_TAG} --nodoc

# Release

ARG DISTRO
ARG CNPG_TAG

FROM ghcr.io/cloudnative-pg/postgresql:${CNPG_TAG}-${DISTRO}

ARG DISTRO
ARG CNPG_TAG

# Do not split the description, otherwise we will see a blank space in the labels
LABEL name="PostgreSQL Container Images" \
      vendor="Glo, The CloudNativePG Contributors" \
      version="${CNPG_TAG}" \
      release="1" \
      summary="PostgreSQL Container images." \
      description="This Docker image contains PostgreSQL and pg_repack based on CNPG ${CNPG_TAG}-${DISTRO}"

USER root

COPY --from=builder /tmp/*.deb /tmp

RUN apt-get update && apt-get install -y --no-install-recommends \
    /tmp/*.deb \
    && rm -rf /var/lib/apt/lists/* /tmp/*

USER postgres
