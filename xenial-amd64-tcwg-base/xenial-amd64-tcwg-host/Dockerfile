# Auto generated from tcwg-base/tcwg-host/Dockerfile.in. Do not edit.
FROM linaro/ci-amd64-tcwg-base-ubuntu:xenial

COPY docker-wrapper /usr/local/bin/docker
COPY docker-stats /usr/local/bin/

COPY run.sh start.sh /

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}-amd64/tini /sbin/tini
RUN chmod +x /sbin/tini

ENTRYPOINT ["/sbin/tini", "--", "/run.sh"]
CMD ["start.sh"]
# checksum: 16a705a5665179382dbfe890bc816637
