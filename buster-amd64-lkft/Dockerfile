FROM debian:buster

COPY *.list *.key /etc/apt/sources.list.d/

RUN dpkg --add-architecture i386 \
 && echo 'locales locales/locales_to_be_generated multiselect C.UTF-8 UTF-8, en_US.UTF-8 UTF-8 ' | debconf-set-selections \
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
 autoconf \
 automake \
 bc \
 bison \
 build-essential \
 ccache \
 chrpath \
 coreutils \
 cpio \
 curl \
 debhelper \
 debian-archive-keyring \
 debian-keyring \
 device-tree-compiler \
 diffstat \
 doxygen \
 fakeroot \
 flex \
 gawk \
 gcc \
 gdisk \
 git \
 kernel-wedge \
 kpartx \
 lava-tool \
 libelf-dev \
 libmagickwand-dev \
 libmath-prime-util-perl \
 libsdl1.2-dev \
 libssl-dev \
 libstdc++6:i386 \
 libtool \
 linaro-image-tools \
 lsb-release \
 openjdk-11-jdk \
 openssh-server \
 pigz \
 python-pip \
 python-requests \
 python3-requests \
 qemu-user-static \
 sudo \
 texinfo \
 time \
 u-boot-tools \
 uuid-dev \
 vim-tiny \
 virtualenv \
 wget \
 whiptail \
 xz-utils \
 zip \
 zlib1g:i386 \
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

USER buildslave

RUN pip install --user --force-reinstall jinja2-cli ruamel.yaml \
 && mkdir -p /home/buildslave/bin \
 && curl https://storage.googleapis.com/git-repo-downloads/repo > /home/buildslave/bin/repo \
 && chmod a+x /home/buildslave/bin/repo

USER root

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
