# Auto generated from tcwg-base/tcwg-host/Dockerfile.in. Do not edit.
FROM linaro/ci-amd64-tcwg-base-ubuntu:xenial

RUN while read line; do \
      new-user.sh --passwd "$line"; \
    done </home-data/passwd

COPY start.sh /
# checksum: cd5ca50ee428e59198a461af6f57d237
