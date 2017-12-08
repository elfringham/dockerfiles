FROM linaro/base-arm64-debian:stretch

COPY *.list *.key /etc/apt/sources.list.d/

RUN apt-get update -q \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gnupg \
 && apt-key add /etc/apt/sources.list.d/*.key \
 && apt-get update -q \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  \
 android-tools-fsutils \
 android-tools-mkbootimg \
 debootstrap \
 dosfstools \
 e2fsprogs \
 fai-server \
 fai-setup-storage \
 gdisk \
 gettext-base \
 git \
 kpartx \
 parted \
 pigz \
 procps \
 qemu-utils \
 wget \
 xz-utils \
 && apt-get clean \
 && rm -rf \
 /etc/apt/sources.list.d/*.key \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

