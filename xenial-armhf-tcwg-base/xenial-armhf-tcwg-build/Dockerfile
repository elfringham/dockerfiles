# Auto generated from tcwg-base/tcwg-build/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-base-ubuntu:xenial

RUN while read line; do \
      if [ x"$(echo "$line" | cut -d: -f 4)" != x"9000" ]; then \
        continue; \
      fi; \
      new-user.sh --passwd "$line"; \
      user=$(echo "$line" | cut -d: -f 1); \
      sudo -i -u $user ccache --print-config; \
    done </home-data/passwd

# checksum: 42236a4db3a31045c88d1a3859571f0f
