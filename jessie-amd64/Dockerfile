FROM debian:jessie

COPY *.list *.key /etc/apt/sources.list.d/

RUN dpkg --add-architecture i386 \
 && echo 'locales locales/locales_to_be_generated multiselect C.UTF-8 UTF-8, en_US.UTF-8 UTF-8 ' | debconf-set-selections \
 && echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections \
 && apt-key add /etc/apt/sources.list.d/*.key \
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
 libstdc++6:i386 \
 libtool \
 libvirt-clients \
 linaro-image-tools \
 lsb-release \
 openssh-server \
 python-requests \
 qemu-user-static \
 sudo \
 time \
 u-boot-tools \
 uuid-dev \
 virtinst \
 wget \
 zip \
 zlib1g:i386 \
 zsync \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -t jessie-backports \
 libsdl1.2-dev \
 openjdk-8-jdk \
 && update-java-alternatives -s java-1.8.0-openjdk-amd64 \
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

