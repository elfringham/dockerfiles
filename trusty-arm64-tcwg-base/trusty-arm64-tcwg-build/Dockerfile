# Auto generated from tcwg-base/tcwg-build/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:trusty

RUN while read line; do \
      if [ x"$(echo "$line" | cut -d: -f 4)" != x"9000" ]; then \
        continue; \
      fi; \
      new-user.sh --passwd "$line"; \
      user=$(echo "$line" | cut -d: -f 1); \
      sudo -i -u $user ccache --print-config; \
    done </home-data/passwd

# checksum: b3846a54f517aff06c5447eb552dd15a
