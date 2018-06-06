# Auto generated from tcwg-base/tcwg-host/Dockerfile.in. Do not edit.
FROM linaro/ci-amd64-tcwg-base-ubuntu:xenial

COPY home-data/ /home-data/

RUN new-user.sh --group tcwg-infra:9000 \
 && new-user.sh --group tcwg-users:10000 \
 && while read line; do \
      new-user.sh --passwd "$line" --home-data /home-data; \
    done </home-data/passwd

COPY start.sh /
# checksum: 67be8ad2fe441805f3c2f1c7a8c1ef99
