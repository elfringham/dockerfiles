FROM ubuntu:utopic

RUN dpkg --add-architecture i386 \
 && sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common \
 && add-apt-repository -y ppa:git-core/ppa \
 && add-apt-repository -y ppa:linaro-maintainers/tools \
 && apt-get update \
 && apt-get dist-upgrade \
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
 && wget -q http://snapshot.debian.org/archive/debian/20151016T034032Z/pool/main/a/acpica-unix/acpica-tools_20150930-1_amd64.deb \
            http://de.archive.ubuntu.com/ubuntu/pool/main/m/make-dfsg/make_3.81-8.2ubuntu3_amd64.deb \
 && dpkg -i --force-all *.deb \
 && apt-mark hold make \
 && apt-get clean
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* *.deb

RUN useradd -m -p '$6$7tSX2YU5Q$ydZwAuWtNPPBb1Fv/tzy3eFeEP/ThDBUjV/4vHVx6bVyfYMX6Q9PYhdV/CyJg7uthSIqIyzlNF65NVB1xwGtt0/' buildslave \
 && echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /var/run/sshd /home/buildslave/bin \
 && curl https://raw.githubusercontent.com/google/styleguide/gh-pages/cpplint/cpplint.py > /home/buildslave/bin/cpplint.py \
 && curl https://storage.googleapis.com/git-repo-downloads/repo > /home/buildslave/bin/repo \
 && chmod a+x /home/buildslave/bin/* \
 && chown -R buildslave:buildslave /home/buildslave/bin \
 && /usr/sbin/sshd
