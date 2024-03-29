FROM debian:stretch

COPY *.list *.key /etc/apt/sources.list.d/

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gnupg \
 && apt-key add /etc/apt/sources.list.d/*.key \
 && echo 'locales locales/locales_to_be_generated multiselect C.UTF-8 UTF-8, en_US.UTF-8 UTF-8 ' | debconf-set-selections \
 && echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y devscripts locales \
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
 cpio \
 curl \
 debhelper \
 debian-archive-keyring \
 debian-keyring \
 debootstrap \
 device-tree-compiler \
 dosfstools \
 doxygen \
 fakeroot \
 flex \
 genisoimage \
 gdisk \
 git \
 kernel-wedge \
 kpartx \
 lava-tool \
 libssl-dev \
 libtool \
 linaro-image-tools \
 lsb-release \
 lvm2 \
 mdadm \
 mtools \
 openjdk-8-jdk \
 openjdk-11-jdk \
 openssh-server \
 parted \
 python-pip \
 python-requests \
 python3-requests \
 qemu-user-static \
 sudo \
 time \
 u-boot-tools \
 uuid-dev \
 wget \
 xz-utils \
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

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
