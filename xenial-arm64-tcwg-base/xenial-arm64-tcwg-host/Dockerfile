# Auto generated from tcwg-base/tcwg-host/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:xenial

COPY home-data/ /home-data/

RUN new-user.sh --group tcwg-infra:9000 \
 && new-user.sh --group tcwg-users:10000 \
 && while read line; do \
      new-user.sh --passwd "$line" --home-data /home-data; \
    done </home-data/passwd

COPY start.sh /
# checksum: 54381e673d7fe46ea4465c482025634b
