FROM oraclelinux:8-slim AS base
LABEL maintainer="jkoehler@novomind.com"

ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION
ARG DOCKER_CLI_VERSION

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="ProtFTP"
LABEL org.label-schema.description="ProFTPD as sFTP service. Current novomind standard for data exchange of the iProducts"
LABEL org.label-schema.url="http://www.proftpd.org/"
LABEL org.label-schema.docker.cmd=""
LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.vcs-url=${VCS_REF}
LABEL org.label-schema.version=${BUILD_VERSION}

ARG PROFTPD_VERSION=1.3.6e-4.el8
ARG OPENSSL_VERSION=1:1.1.1k-6.el8_5

RUN microdnf -y update && \
        microdnf -y install epel-release && \
        microdnf -y update && \
        microdnf -y install proftpd-${PROFTPD_VERSION} proftpd-utils-${PROFTPD_VERSION} openssl-${OPENSSL_VERSION} && \
        microdnf -y clean all

RUN useradd -M -s /sbin/nologin -U proftpd && \
        mkdir -p /srv/proftpd/logs/

WORKDIR /

COPY --chmod=0600 ./id_rsa etc/proftpd/id_rsa
COPY --chmod=0600 ./id_ecdsa etc/proftpd/id_ecdsa

USER proftpd

FROM scratch

COPY --from=base ./docker-entrypoint.sh /usr/sbin/docker-entrypoint.sh
RUN chmod a+x /usr/sbin/docker-entrypoint.sh

ENTRYPOINT ["/usr/sbin/docker-entrypoint.sh"]
