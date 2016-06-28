FROM quay.io/fathi_boudra/ubuntu:trusty-armhf

COPY *.list *.key /etc/apt/sources.list.d/

RUN echo 'deb http://ports.ubuntu.com/ubuntu-ports trusty main universe' > /etc/apt/sources.list \
 && apt-key add /etc/apt/sources.list.d/*.key \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y devscripts \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 alien \
 autoconf \
 autogen \
 automake \
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
 libtool \
 make \
 net-tools \
 netcat \
 openjdk-7-jdk \
 openssh-server \
 python-dev \
 qemu-user \
 sudo \
 texinfo \
 texlive-fonts-recommended \
 texlive-latex-recommended \
 time \
 vim \
 wget \
 xz-utils \
 zlib1g-dev \
 && apt-get clean \
 && rm -rf \
 /etc/apt/sources.list.d/*.key \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN groupadd -g 9000 tcwg-infra \
 && useradd -m -g tcwg-infra -u 11827 tcwg-buildslave \
 && echo 'tcwg-buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 440 /etc/sudoers.d/jenkins \
 && install -D -p -m0755 /usr/share/doc/git/contrib/workdir/git-new-workdir /usr/local/bin/git-new-workdir \
 && sed -i -e 's:^session *required *pam_loginuid.so:# session required pam_loginuid.so:' /etc/pam.d/sshd \
 && mkdir -p /var/run/sshd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

VOLUME /srv/docker/ssh/id_rsa_tcwg-buildslave.pub:/home/tcwg-buildslave/.ssh/authorized_keys:ro
VOLUME /srv/docker/ssh/tcwg-buildslave.config:/home/tcwg-buildslave/.ssh/config:ro
VOLUME /home/tcwg-buildslave/snapshots-ref:/home/tcwg-buildslave/snapshots-ref:ro
VOLUME /home/tcwg-buildslave/workspace:/home/tcwg-buildslave/workspace:rw
VOLUME /tmp
