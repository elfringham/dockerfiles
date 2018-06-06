# Auto generated from tcwg-base/tcwg-build/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-base-ubuntu:xenial

COPY home-data/ /home-data/

RUN new-user.sh --group tcwg-infra:9000 \
 && while read line; do \
      if [ x"$(echo "$line" | cut -d: -f 4)" != x"9000" ]; then \
        continue; \
      fi; \
      new-user.sh --passwd "$line" --home-data /home-data; \
    done </home-data/passwd \
 && rm -rf /home-data/ \
 && mkdir -p /home/tcwg-buildslave/workspace

# checksum: ca85feb4461f9dc3362608076a79ac5f
