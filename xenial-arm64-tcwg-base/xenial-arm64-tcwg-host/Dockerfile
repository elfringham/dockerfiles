# Auto generated from tcwg-base/tcwg-host/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:xenial

RUN while read line; do \
      new-user.sh --passwd "$line"; \
    done </home-data/passwd

COPY start.sh /
# checksum: fa6283dd5f4ffd4d684ee8d318a09a77
