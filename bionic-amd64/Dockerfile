FROM ubuntu:bionic

RUN dpkg --add-architecture i386 \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common \
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
 clang \
 clang-format \
 clang-tidy \
 curl \
 debhelper \
 debian-archive-keyring \
 debian-keyring \
 device-tree-compiler \
 doxygen \
 fakeroot \
 flex \
 gcc \
 gcc-aarch64-linux-gnu \
 gcc-arm-linux-gnueabihf \
 gdisk \
 genisoimage \
 git \
 gperf \
 kernel-wedge \
 kpartx \
 lava-tool \
 lcov \
 less \
 lib32ncurses5 \
 libstdc++6:i386 \
 libtool \
 libvirt-bin \
 libxml2-utils \
 lsb-release \
 make \
 openjdk-11-jdk \
 openssh-server \
 python-cryptography \
 python-mako \
 python-networkx \
 python-pip \
 python-requests \
 python-wheel \
 python3-cryptography \
 python3-pip \
 python3-requests \
 python3-wheel \
 pxz \
 qemu-user-static \
 rsync \
 scons \
 sudo \
 time \
 u-boot-tools \
 uuid-dev \
 virtinst \
 wget \
 xml-twig-tools \
 zip \
 zlib1g-dev:i386 \
 zsync \
 && apt-get clean \
 && rm -rf \
 /etc/apt/sources.list.d/*.key \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/* \
 *.deb

RUN useradd -m -G plugdev buildslave \
 && echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /var/run/sshd /home/buildslave/bin \
 && curl https://raw.githubusercontent.com/google/styleguide/gh-pages/cpplint/cpplint.py > /home/buildslave/bin/cpplint.py \
 && curl https://storage.googleapis.com/git-repo-downloads/repo > /home/buildslave/bin/repo \
 && chmod a+x /home/buildslave/bin/* \
 && chown -R buildslave:buildslave /home/buildslave/bin

RUN pip install jenkins-job-builder==2.10.0 \
 && git clone --depth 1 https://git.linaro.org/infrastructure/jjb-linaro-plugin.git \
 && cd jjb-linaro-plugin && python setup.py install && cd .. && rm -rf jjb-linaro-plugin

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

