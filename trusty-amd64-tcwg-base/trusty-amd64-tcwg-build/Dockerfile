# Auto generated from tcwg-base/tcwg-build/Dockerfile.in. Do not edit.
FROM linaro/ci-amd64-tcwg-base-ubuntu:trusty

COPY tcwg-buildslave /home-data/tcwg-buildslave
COPY tcwg-benchmark /home-data/tcwg-benchmark

RUN new-user.sh --group tcwg-infra:9000 \
 && new-user.sh --passwd "tcwg-buildslave:x:11827:9000:TCWG Buildslave::/bin/bash" --home-data /home-data \
 && new-user.sh --passwd "tcwg-benchmark:x:12326:9000:TCWG Benchmark::/bin/bash" --home-data /home-data \
 && rm -rf /home-data/ \
 && mkdir -p /home/tcwg-buildslave/workspace

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
# checksum: 597468c184f0538f41715771c44d58cf
