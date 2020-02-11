# Auto generated from tcwg-base/tcwg-host/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-base-ubuntu:xenial

COPY docker-wrapper /usr/local/bin/docker
COPY docker-stats /usr/local/bin/

COPY run.sh start.sh /

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}-armhf/tini /sbin/tini
RUN chmod +x /sbin/tini

ENTRYPOINT ["/sbin/tini", "--", "linux32", "/run.sh"]
CMD ["start.sh"]
# checksum: 120fbdeafb494efffcec4d85b74ebcd1
