FROM ubuntu:xenial

COPY tcwg-buildslave/.ssh /etc/skel/.ssh

RUN dpkg --add-architecture i386 \
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
 ccache \
 ccrypt \
 byacc \
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

RUN chmod 0700 /etc/skel/.ssh \
 && groupadd -g 9000 tcwg-infra \
 && useradd -m -g tcwg-infra -u 11827 tcwg-buildslave \
 && rm -rf /etc/skel/.ssh \
 && echo 'tcwg-buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 440 /etc/sudoers.d/jenkins \
 && install -D -p -m0755 /usr/share/doc/git/contrib/workdir/git-new-workdir /usr/local/bin/git-new-workdir \
 && sed -i -e 's:^session *required *pam_loginuid.so:# session required pam_loginuid.so:' /etc/pam.d/sshd \
 && mkdir -p /var/run/sshd \
 && sed -i \
 -e "/.*MaxStartups.*/d" \
 -e "/.*MaxSesssions.*/d" \
 && echo "MaxStartups 256" >> /etc/ssh/sshd_config \
 && echo "MaxSessions 256" >> /etc/ssh/sshd_config \
 && mkdir -p /home/tcwg-buildslave/workspace \
 && chown tcwg-buildslave:tcwg-infra /home/tcwg-buildslave/workspace

# Unfortunately, VOLUME doesn't support bind-mounts for portability reasons.
# Therefore, the bind-mounts for the following paths are configured in
# the ci.linaro.org's docker plugin.
# Sources caches (read-only):
# /home/tcwg-buildslave/snapshots-ref:/home/tcwg-buildslave/snapshots-ref:ro
# Jenkins .jar cache (read-write):
# /home/tcwg-buildslave/.jenkins:/home/tcwg-buildslave/.jenkins:rw

# We write most of the data inside workspace, so make it a scratch mount.
# Note that bind-mounting workspace from host will make jobs with parallel
# builds fail.
VOLUME /home/tcwg-buildslave/workspace

# We use ssh multiplexing, which creates sockets in /tmp.  Overlayfs,
# which docker is using can't host sockets, so we use a scratch mount
# for /tmp.  This requires that we add --rm option to "docker run"
# invocations (e.g., mark "Remove volumes" checkbox in docker plugin) to
# cleanup host directories used for the scratch mounts.
VOLUME /tmp

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
