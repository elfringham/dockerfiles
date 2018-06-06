# Auto generated from tcwg-base/tcwg-build/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-base-ubuntu:trusty

COPY home-data/ /home-data/

RUN new-user.sh --group tcwg-infra:9000 \
 && while read line; do \
      if [ x"$(echo "$line" | cut -d: -f 4)" != x"9000" ]; then \
        continue; \
      fi; \
      new-user.sh --passwd "$line" --home-data /home-data; \
    done </home-data/passwd \
 && rm -rf /home-data/

# checksum: a71bd21690ec22f250dd6652fbefcb3c
