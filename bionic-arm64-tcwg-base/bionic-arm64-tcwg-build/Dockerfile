# Auto generated from tcwg-base/tcwg-build/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:bionic

RUN while read line; do \
      if [ x"$(echo "$line" | cut -d: -f 4)" != x"9000" ]; then \
        continue; \
      fi; \
      new-user.sh --passwd "$line"; \
      user=$(echo "$line" | cut -d: -f 1); \
      sudo -i -u $user ccache --print-config; \
    done </home-data/passwd

# checksum: d071ac6057c0379ee9a9703958bae536
