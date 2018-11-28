# Auto generated from tcwg-base/tcwg-host/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-base-ubuntu:xenial

COPY docker-wrapper /usr/local/bin/docker
COPY docker-stats /usr/local/bin/

COPY run.sh start.sh /

ENTRYPOINT ["linux32", "/run.sh"]
CMD ["start.sh"]
# checksum: ba7a02aa96c3b6df313c3fac751b47bc
