# Auto generated from tcwg-base/tcwg-build/Dockerfile.in. Do not edit.
FROM linaro/ci-amd64-tcwg-base-ubuntu:xenial

RUN while read line; do \
      if [ x"$(echo "$line" | cut -d: -f 4)" != x"9000" ]; then \
        continue; \
      fi; \
      new-user.sh --passwd "$line"; \
    done </home-data/passwd

# Install wine.  On amd64 arch we need to enable i386, otherwise wine
# won't meet dependencies (this is the case at least for trusty and xenial).
RUN \
 dpkg --add-architecture i386 && \
 apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 wine \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*
# checksum: 5ec4314bb47180f2d9b6430d56a1292f
