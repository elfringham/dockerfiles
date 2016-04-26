# TCWG configuration with everything needed to build the GNU toolchain and test it.
# To run the resulting image manually and mount /tmp to /mnt, use:
#         docker run -i -v /tmp:/mnt -t tcwg/wily-amd64-tcwg /bin/bash
FROM quay.io/fathi_boudra/ubuntu:trusty-i386

COPY *.list *.key /etc/apt/sources.list.d/

RUN for key in $(ls /etc/apt/sources.list.d/*.key); do apt-key add ${key}; done \
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
 bison \
 build-essential \
 byacc \
 debhelper \
 dejagnu \
 dh-autoreconf \
 dh-translations \
 distro-info-data \
 fakeroot \
 flex \
 git \
 g++-multilib \
 gawk \
 git \
 libexpat1-dev \
 liblzma-dev \
 libncurses5-dev \
 libreadline-dev \
 libtool \
 lsb-build-c++ \
 lsb-build-cc \
 lsb-release \
 netcat \
 openjdk-7-jdk \
 openssh-server \
 python-dev \
 sudo \
 mingw-w64 \
 texinfo \
 texlive-fonts-recommended \
 texlive-latex-recommended \
 time \
 vim \
 wget \
 wine \
 xz-utils \
 zlib1g-dev \
 && find /opt -type d |xargs chmod 0755 \
 && wget -q http://de.archive.ubuntu.com/ubuntu/pool/main/m/make-dfsg/make_3.81-8.2ubuntu3_i386.deb \
 && dpkg -i --force-all *.deb \
 && apt-mark hold make \
 && apt-get clean \
 && rm -rf \
 /etc/apt/sources.list.d/*.key \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/* \
 *.deb

RUN groupadd -g 9000 tcwg-infra \
 && useradd -m -g tcwg-infra -u 11827 tcwg-buildslave \
 && echo 'tcwg-buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 440 /etc/sudoers.d/jenkins \
 && echo 'PATH="/opt/lsb/bin:$PATH"' >> /home/tcwg-buildslave/.profile \
 && install -D -p -m0755 /usr/share/doc/git/contrib/workdir/git-new-workdir /usr/local/bin/git-new-workdir \
 && sed -i -e 's:^session *required *pam_loginuid.so:# session required pam_loginuid.so:' /etc/pam.d/sshd \
 && mkdir -p /var/run/sshd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
