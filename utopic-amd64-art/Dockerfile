FROM ubuntu:utopic

RUN dpkg --add-architecture i386 \
 && sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common \
 && add-apt-repository -y ppa:git-core/ppa \
 && add-apt-repository -y ppa:linaro-maintainers/tools \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
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
 libxml2-utils \
 make \
 openssh-client \
 openssh-server \
 python-mako \
 python-networkx \
 python-pycurl \
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
 http://mirrors.kernel.org/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jre-headless_8u45-b14-1_amd64.deb \
 http://mirrors.kernel.org/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jre_8u45-b14-1_amd64.deb \
 http://mirrors.kernel.org/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jdk_8u45-b14-1_amd64.deb \
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

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
