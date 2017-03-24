FROM linaro/base-i386-ubuntu:xenial

RUN (url="http://archive.ubuntu.com/ubuntu/"; \
 ubuntu=xenial; \
 for i in $ubuntu $ubuntu-updates $ubuntu-backports $ubuntu-security; do \
   for j in deb deb-src; do \
     echo "$j $url $i main restricted universe multiverse"; \
   done; \
   echo; \
 done) > /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && dpkg-divert --local --rename --add /sbin/initctl \
 && ln -s /bin/true /sbin/initctl \
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
 net-tools \
 netcat \
 ninja-build \
 openjdk-8-jdk \
 openssh-server \
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
 virtualenv \
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

# We use ssh multiplexing, which creates sockets in /tmp.  Overlayfs,
# which docker is using, can't host sockets, so we use a scratch mount
# for /tmp.  This requires that we add --rm option to "docker run"
# invocations (e.g., mark "Remove volumes" checkbox in docker plugin) to
# cleanup host directories used for the scratch mounts.
VOLUME /tmp

EXPOSE 22
CMD ["linux32", "/usr/sbin/sshd", "-D"]
