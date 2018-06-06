# Auto generated from tcwg-base/tcwg-host/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:xenial

COPY passwd start.sh /
COPY home-data/ /home-data/

RUN new-user.sh --group tcwg-infra:9000 && new-user.sh --group tcwg-users:10000 \
 && while read line; do \
      new-user.sh --passwd "$line" --home-data /home-data; \
    done </passwd \
 && rm -rf /passwd /home-data/
# checksum: ec94afcaca03b088611a5457c8d37222
