# Auto generated from tcwg-base/Dockerfile.in. Do not edit.
FROM ubuntu:focal

# Unminimize Ubuntu Bionic to install contrib files of git (after package
# update, otherwise unminimize's "apt upgrade" might fail).
RUN true \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && echo y | unminimize \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y devscripts \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 alien \
 autoconf \
 autogen \
 automake \
 bc \
 bind9-host \
 bison \
 binutils-aarch64-linux-gnu \
 binutils-arm-linux-gnueabihf \
 binutils-dev \
 bsd-mailx \
 build-essential \
 byacc \
 ccache \
 ccrypt \
 chrpath \
 clang \
 cmake \
# cpufrequtils is used by our benchmarking scripts, but we should update them to
# use cpupower from linux-tools everywhere instead.
 cpufrequtils \
 curl \
 debhelper \
 dejagnu \
 dh-autoreconf \
 dh-translations \
 distro-info-data \
 emacs \
 fakeroot \
 flex \
 gawk \
 gdb \
 gdbserver \
 git \
 groff \
 less \
 libexpat1-dev \
 libffi-dev \
 libgmp-dev \
 liblzma-dev \
 libmpc-dev \
 libmpfr-dev \
 libncurses5-dev \
 libpython2.7-dev \
 libreadline-dev \
 libssl-dev \
 libtcnative-1 \
 libtool \
 linux-tools-common \
# We want to control the perf version used by the benchmarking jobs.
# These versions have proven to work on TK1s and TX1s kernels.
 locales \
 lzop \
 make \
 mingw-w64 \
 moreutils \
 net-tools \
 netcat \
 nfs-kernel-server \
 ninja-build \
 ntp \
 openjdk-8-jdk \
 openssh-server \
 postfix \
 psmisc \
# pxz \
 python2-dev \
# python2-pip \
# python2-setuptools \
# python2-wheel \
 python3-dev \
 python3-pip \
 python3-setuptools \
 python3-wheel \
 rsync \
 subversion \
 sudo \
 tclsh \
 texinfo \
 texlive-fonts-recommended \
 texlive-latex-recommended \
 time \
 unifdef \
 valgrind \
 vim \
 virtualenv \
 wget \
 xz-utils \
 zip \
 zlib1g-dev \
 shellcheck \
# Update tzdata, because some base images have an incorrect file for UTC.
 && DEBIAN_FRONTEND=noninteractive apt-get install --reinstall tzdata \
 && rm -f /etc/ssh/ssh_host_*_key* \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN install -D -p -m0755 /usr/share/doc/git/contrib/workdir/git-new-workdir /usr/local/bin/git-new-workdir \
 && sed -i -e 's:^session *required *pam_loginuid.so:# session required pam_loginuid.so:' /etc/pam.d/sshd \
 && mkdir -p /var/run/sshd \
 && sed -i \
 -e "/.*MaxStartups.*/d" \
 -e "/.*MaxSessions.*/d" /etc/ssh/sshd_config \
 && echo "MaxStartups 256" >> /etc/ssh/sshd_config \
 && echo "MaxSessions 256" >> /etc/ssh/sshd_config \
 && locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 \
 && pip3 install git-review

# Install jipdate.  It is tricky to make these work
# for Trusty and Xenial, so don't bother.
RUN git clone -b master https://github.com/Linaro/jipdate.git /usr/local/jipdate/ \
 && git -C /usr/local/jipdate/ fetch origin pull/36/head:pull-36 \
 && git -C /usr/local/jipdate/ checkout pull-36 \
 && pip3 install -U -r /usr/local/jipdate/requirements.txt \
 && ln -s /usr/local/jipdate/jipdate.py /usr/local/bin/jipdate.py

COPY postfix-main.cf.in /etc/postfix/main.cf
COPY postfix-sasl_password.in /etc/postfix/sasl_password

RUN chown root:root /etc/postfix/sasl_password \
 && chmod 600 /etc/postfix/sasl_password

# Add ninja with support for memory-threshold job limitation.
# It's installed with ".bin" extension and containers then
# make wrappers around it in /usr/local/bin/ninja as needed.
RUN git clone -b master https://github.com/maxim-kuvyrkov/ninja.git \
 && cd ninja \
 && ./configure.py --bootstrap && ./ninja all && ./ninja_test \
 && mv ninja /usr/local/bin/ninja.bin \
 && cd .. \
 && rm -rf ninja

# Build latest QEMU release (and install pre-requisites for the build).
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 libglib2.0-dev \
 libpixman-1-dev \
 pkg-config \
 && mkdir /tmp/docker-install-qemu.$$ \
 && cd /tmp/docker-install-qemu.$$ \
 && qemu_ver=4.2.0 \
 && wget --progress=dot:giga http://download.qemu-project.org/qemu-${qemu_ver}.tar.xz \
 && tar xf qemu-${qemu_ver}.tar.xz \
 && mkdir build && cd build \
 && ../qemu-${qemu_ver}/configure --prefix=/usr/local --target-list=aarch64-softmmu,arm-softmmu,aarch64-linux-user,aarch64_be-linux-user,arm-linux-user,armeb-linux-user \
 && make all install -j $(nproc --all) \
 && apt-get clean \
 && rm -rf \
 /tmp/docker-install-qemu.$$ \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

COPY home-data/ /home-data/
COPY new-user.sh /usr/local/bin/

RUN \
 while read line; do \
   new-user.sh --group $(echo "$line" | cut -d: -f 1,3); \
 done </home-data/group

# We use ssh multiplexing, which creates sockets in /tmp.  Overlayfs,
# which docker is using, can't host sockets, so we use a scratch mount
# for /tmp.  This requires that we add --rm option to "docker run"
# invocations (e.g., mark "Remove volumes" checkbox in docker plugin) to
# cleanup host directories used for the scratch mounts.
VOLUME /tmp

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
# checksum: 56d029ef3758a2a8fb670febe531d630
