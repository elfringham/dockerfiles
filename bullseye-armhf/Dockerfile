FROM arm32v7/debian:bullseye

RUN echo 'locales locales/locales_to_be_generated multiselect C.UTF-8 UTF-8, en_US.UTF-8 UTF-8 ' | debconf-set-selections \
 && echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections \
 && apt-get -q update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -qy \
 && DEBIAN_FRONTEND=noninteractive apt-get install -qy devscripts locales \
 && DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends \
 abootimg \
 acpica-tools \
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
 libtool \
 libssl-dev \
 lsb-release \
 lvm2 \
 mdadm \
 mtools \
 openjdk-11-jdk \
 openssh-server \
 parted \
 python3-cryptography \
 python3-pip \
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
