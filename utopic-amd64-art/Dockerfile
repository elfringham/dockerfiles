FROM ubuntu:utopic

COPY setup-sshd /usr/sbin/setup-sshd

RUN dpkg --add-architecture i386 \
 && echo 'locales locales/locales_to_be_generated multiselect C.UTF-8 UTF-8, en_US.UTF-8 UTF-8 ' | debconf-set-selections \
 && echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections \
 && sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common \
 && add-apt-repository -y ppa:git-core/ppa \
 && add-apt-repository -y ppa:linaro-maintainers/tools \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 acpica-tools \
 android-tools-adb \
 bc \
 bison \
 ccache \
 clang \
 curl \
 default-jdk \
 gcc-4.6 \
 g++-multilib \
 genisoimage \
 git \
 gperf \
 lcov \
 less \
 lib32ncurses5 \
 libtcnative-1 \
 libxml2-utils \
 make \
 openssh-client \
 openssh-server \
 patch \
 parallel \
 python-mako \
 python-networkx \
 python-requests \
 rsync \
 scons \
 time \
 unzip \
 wget \
 xml-twig-tools \
 zip \
 zlib1g-dev:i386 \
 && wget -q \
 http://snapshot.debian.org/archive/debian/20160609T104519Z/pool/main/a/acpica-unix/acpica-tools_20160527-1_amd64.deb \
 http://de.archive.ubuntu.com/ubuntu/pool/main/m/make-dfsg/make_3.81-8.2ubuntu3_amd64.deb \
 http://mirrors.edge.kernel.org/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jre-headless_8u181-b13-1_amd64.deb \
 http://mirrors.edge.kernel.org/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jre_8u181-b13-1_amd64.deb \
 http://mirrors.edge.kernel.org/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jdk_8u181-b13-1_amd64.deb \
 && dpkg -i --force-all *.deb \
 && apt-mark hold make \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* *.deb

RUN useradd -m -G plugdev buildslave \
 && echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /var/run/sshd /home/buildslave/bin \
 && curl https://raw.githubusercontent.com/google/styleguide/gh-pages/cpplint/cpplint.py > /home/buildslave/bin/cpplint.py \
 && curl https://storage.googleapis.com/git-repo-downloads/repo > /home/buildslave/bin/repo \
 && chmod a+x /home/buildslave/bin/* \
 && chown -R buildslave:buildslave /home/buildslave/bin

ENV LC_ALL C.UTF-8

EXPOSE 22
ENTRYPOINT ["/usr/sbin/setup-sshd"]
