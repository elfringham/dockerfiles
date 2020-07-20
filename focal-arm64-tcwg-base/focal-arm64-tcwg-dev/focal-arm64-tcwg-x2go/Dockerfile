# Auto generated from tcwg-base/tcwg-dev/tcwg-x2go/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-dev-ubuntu:focal

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
 light-themes \
 mate-desktop-environment \
 ubuntu-mate-themes \
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
# checksum: 4bda7b2aaf0b0474e0fe6bfc2a4b4a95
