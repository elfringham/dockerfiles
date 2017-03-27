FROM ubuntu:trusty

RUN (url="http://archive.ubuntu.com/ubuntu/"; \
 ubuntu=trusty; \
 for i in $ubuntu $ubuntu-updates $ubuntu-backports $ubuntu-security; do \
   for j in deb deb-src; do \
     echo "$j $url $i main restricted universe multiverse"; \
   done; \
   echo; \
 done) > /etc/apt/sources.list \
 && dpkg --add-architecture i386 \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y devscripts \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 alien \
 autoconf \
 autogen \
 automake \
 bc \
 bison \
 build-essential \
 byacc \
 ccache \
 ccrypt \
 cmake \
 debhelper \
 dejagnu \
 dh-autoreconf \
 dh-translations \
 distro-info-data \
 emacs \
 fakeroot \
 flex \
 g++-multilib \
 gawk \
 gdb \
 gdbserver \
 git \
 libexpat1-dev \
 libglib2.0-dev \
 liblzma-dev \
 libncurses5-dev \
 libpython2.7-dev \
 libreadline-dev \
 libssl-dev \
 libtcnative-1 \
 libtool \
 lzop \
 make \
 mingw-w64 \
 mingw32 \
 net-tools \
 netcat \
 ninja-build \
 openjdk-7-jdk \
 openssh-server \
 pkg-config \
 python-dev \
 pxz \
 qemu-user \
 rsync \
 sudo \
 texinfo \
 texlive-fonts-recommended \
 texlive-latex-recommended \
 time \
 valgrind \
 vim \
 wget \
 wine \
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
 -e "/.*MaxSesssions.*/d" /etc/ssh/sshd_config \
 && echo "MaxStartups 256" >> /etc/ssh/sshd_config \
 && echo "MaxSessions 256" >> /etc/ssh/sshd_config

RUN mkdir /tmp/docker-install-qemu.$$ \
 && cd /tmp/docker-install-qemu.$$ \
 && qemu_ver=2.8.0 && wget --progress=dot:giga http://download.qemu-project.org/qemu-${qemu_ver}.tar.xz \
 && tar xf qemu-${qemu_ver}.tar.xz \
 && mkdir build && cd build \
 && ../qemu-${qemu_ver}/configure --prefix=/usr/local --target-list=armeb-linux-user \
 && make all install -j $(nproc --all) \
 && cd && rm -rf /tmp/docker-install-qemu.$$

# We use ssh multiplexing, which creates sockets in /tmp.  Overlayfs,
# which docker is using, can't host sockets, so we use a scratch mount
# for /tmp.  This requires that we add --rm option to "docker run"
# invocations (e.g., mark "Remove volumes" checkbox in docker plugin) to
# cleanup host directories used for the scratch mounts.
VOLUME /tmp

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
