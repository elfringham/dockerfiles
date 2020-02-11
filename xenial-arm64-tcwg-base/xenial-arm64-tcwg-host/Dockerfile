# Auto generated from tcwg-base/tcwg-host/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:xenial

COPY docker-wrapper /usr/local/bin/docker
COPY docker-stats /usr/local/bin/

COPY run.sh start.sh /

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}-arm64/tini /sbin/tini
RUN chmod +x /sbin/tini

ENTRYPOINT ["/sbin/tini", "--", "/run.sh"]
CMD ["start.sh"]
# checksum: f68590e5a0e6a62c88271098df9d2d0f
