# Auto generated from tcwg-base/Dockerfile.in. Do not edit.
FROM linaro/base-arm64-ubuntu:xenial

RUN (url="http://ports.ubuntu.com/ubuntu-ports/"; \
 ubuntu=xenial; \
 for i in $ubuntu $ubuntu-updates $ubuntu-backports $ubuntu-security; do \
   for j in deb deb-src; do \
     echo "$j $url $i main restricted universe multiverse"; \
   done; \
   echo; \
 done) > /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y devscripts \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 alien \
 autoconf \
 autogen \
 automake \
 bc \
 bind9-host \
 bison \
 binutils-dev \
 bsd-mailx \
 build-essential \
 byacc \
 ccache \
 ccrypt \
 chrpath \
 clang \
 cmake \
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
 git-review \
 groff \
 less \
 libexpat1-dev \
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
 linux-tools-generic \
 locales \
 lzop \
 make \
 moreutils \
 net-tools \
 netcat \
 nfs-kernel-server \
 ninja-build \
 openjdk-8-jdk \
 openssh-server \
 python-dev \
 postfix \
 psmisc \
 pxz \
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
 && locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

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
# Install qemu-system-common to configure rootfs for KVM virtualization
# (e.g., create "kvm" user group, which we expect to exist in newuser.sh).
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 libglib2.0-dev \
 libpixman-1-dev \
 pkg-config \
 qemu-system-common \
 && mkdir /tmp/docker-install-qemu.$$ \
 && cd /tmp/docker-install-qemu.$$ \
 && qemu_ver=3.1.0 && wget --progress=dot:giga http://download.qemu-project.org/qemu-${qemu_ver}.tar.xz \
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
# checksum: ba68504e256a3e7bc11ce6b4fab460e7
