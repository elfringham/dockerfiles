FROM linaro/base-arm64-ubuntu:xenial

COPY *.list *.key /etc/apt/sources.list.d/

RUN echo 'deb http://ports.ubuntu.com/ubuntu-ports xenial main universe' > /etc/apt/sources.list \
 && apt-key add /etc/apt/sources.list.d/*.key \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y devscripts \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 abootimg \
 acpica-tools \
 android-tools-fsutils \
 autoconf \
 automake \
 bc \
 bison \
 build-essential \
 ccache \
 clang-format-3.8 \
 clang-tidy-3.8 \
 curl \
 debhelper \
 debian-archive-keyring \
 debian-keyring \
 device-tree-compiler \
 doxygen \
 fakeroot \
 flex \
 gcc \
 gdisk \
 git \
 kernel-wedge \
 kpartx \
 lava-tool \
 libtool \
 libvirt-bin \
 linaro-image-tools \
 lsb-release \
 openjdk-8-jdk \
 openssh-server \
 python-requests \
 python3-requests \
 qemu-user-static \
 sudo \
 time \
 u-boot-tools \
 uuid-dev \
 virtinst \
 wget \
 zip \
 zsync \
 && apt-get clean \
 && rm -rf \
 /etc/apt/sources.list.d/*.key \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN useradd -m buildslave \
 && echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 440 /etc/sudoers.d/jenkins \
 && mkdir -p /var/run/sshd

VOLUME ["/var/lib/libvirt"]

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
