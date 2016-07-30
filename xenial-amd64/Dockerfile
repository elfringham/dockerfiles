FROM ubuntu:xenial

COPY *.list *.key /etc/apt/sources.list.d/

RUN dpkg --add-architecture i386 \
 && apt-key add /etc/apt/sources.list.d/*.key \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common \
 && add-apt-repository -y ppa:git-core/ppa \
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
 clang-format-3.6 \
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
 libxml2-utils \
 linaro-image-tools \
 lsb-release \
 make \
 openjdk-8-jdk \
 openssh-server \
 python-mako \
 python-networkx \
 python-pycurl \
 qemu-user-static \
 rsync \
 scons \
 sudo \
 time \
 u-boot-tools \
 uuid-dev \
 wget \
 xml-twig-tools \
 zip \
 zlib1g-dev:i386 \
 zsync \
 && wget -q \
 http://de.archive.ubuntu.com/ubuntu/pool/main/m/make-dfsg/make_3.81-8.2ubuntu3_amd64.deb \
 && dpkg -i --force-all *.deb \
 && apt-mark hold make \
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

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
