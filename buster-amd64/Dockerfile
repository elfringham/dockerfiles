FROM debian:buster-backports

COPY *.list *.key /etc/apt/sources.list.d/

RUN echo 'locales locales/locales_to_be_generated multiselect C.UTF-8 UTF-8, en_US.UTF-8 UTF-8 ' | debconf-set-selections \
 && echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections \
 && apt-get update \
 ; DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gnupg \
 && apt-key add /etc/apt/sources.list.d/*.key \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y devscripts locales \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 abootimg \
 acpica-tools \
 android-tools-fsutils \
 ansible/buster-backports \
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
 gdisk \
 genisoimage \
 git \
 kernel-wedge \
 kpartx \
 lava-tool \
 libcurl4-openssl-dev \
 libssl-dev \
 libtool \
 lsb-release \
 lvm2 \
 mdadm \
 mtools \
 openjdk-11-jdk \
 openssh-server \
 parted \
 pigz \
 python3-jinja2 \
 python3-kerberos \
 python3-pip \
 python3-requests \
 python3-ruamel.yaml \
 qemu-user-static \
 sudo \
 time \
 u-boot-tools \
 uuid-dev \
 wget \
 xz-utils \
 zip \
 zsync \
 && if [ $(uname -m) = 'x86_64' ]; then \
   DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
   g++-multilib \
   libc6-dev-i386; fi \
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
 && wget -q http://deb.debian.org/debian/pool/contrib/r/repo/repo_2.10-1~bpo10+1_all.deb \
 && apt install ./repo_*.deb \
 && rm -f *.deb

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
