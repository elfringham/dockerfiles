# Auto generated from tcwg-base/tcwg-dev/tcwg-x2go/Dockerfile.in. Do not edit.
FROM linaro/ci-amd64-tcwg-dev-ubuntu:focal

COPY start.sh .

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 ubuntu-desktop \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 duplicity \
 mate-desktop-environment \
 x2goserver \
 x2goserver-xsession \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 ddd \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*
# checksum: 399f2dc834ae480aece63ada34ca6ae8
