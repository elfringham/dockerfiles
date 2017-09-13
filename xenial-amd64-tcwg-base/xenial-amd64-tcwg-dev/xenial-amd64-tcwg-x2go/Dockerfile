# Auto generated from tcwg-base/tcwg-dev/tcwg-x2go/Dockerfile.in. Do not edit.
FROM linaro/ci-amd64-tcwg-dev-ubuntu:xenial

COPY start.sh .

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 ubuntu-desktop \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN add-apt-repository ppa:x2go/stable \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 duplicity \
 mate-desktop-environment \
 x2godesktopsharing \
 x2gomatebindings \
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
# checksum: 3e1c139ac1715b1096130c6e90c55fc9
