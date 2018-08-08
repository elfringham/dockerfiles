# Auto generated from tcwg-base/tcwg-host/Dockerfile.in. Do not edit.
FROM linaro/ci-amd64-tcwg-base-ubuntu:xenial

COPY docker-wrapper /usr/local/bin/docker
COPY docker-stats /usr/local/bin/

COPY run.sh start.sh /

ENTRYPOINT ["/run.sh"]
CMD ["start.sh"]
# checksum: 9f94a8be2756ffabb6ebafa75127f228
