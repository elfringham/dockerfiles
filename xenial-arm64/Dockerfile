FROM quay.io/fathi_boudra/ubuntu:xenial-arm64

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
 libguestfs-tools \
 libtool \
 libvirt-clients \
 linaro-image-tools \
 lsb-release \
 openjdk-8-jdk \
 openssh-server \
 python-pycurl \
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
 && mkdir -p /var/run/sshd \
 && echo 'uri_default = "qemu+tcp://172.17.0.1/system"' >> /etc/libvirt/libvirt.conf

VOLUME ["/var/lib/libvirt"]

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
