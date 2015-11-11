FROM ubuntu:wily

COPY *.list *.key /etc/apt/sources.list.d/

RUN dpkg --add-architecture i386 \
 && for key in $(ls /etc/apt/sources.list.d/*.key); do apt-key add ${key}; done \
 && apt-get update \
 && apt-get dist-upgrade \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y devscripts \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 alien \
 autoconf \
 automake \
 bc \
 bison \
 build-essential \
 ccache \
 curl \
 debhelper \
 dejagnu \
 flex \
 g++-multilib \
 gcc \
 git \
 lsb-release \
 openjdk-7-jdk \
 openssh-server \
 qemu-user-static \
 sudo \
 time \
 wget \
 && wget -q http://de.archive.ubuntu.com/ubuntu/pool/main/m/make-dfsg/make_3.81-8.2ubuntu3_amd64.deb \
 && dpkg -i --force-all *.deb \
 && apt-mark hold make \
 && apt-get clean \
 && rm -rf \
 /etc/apt/sources.list.d/*.key \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/* \
 *.deb

RUN useradd -m -p '$6$7tSX2YU5Q$ydZwAuWtNPPBb1Fv/tzy3eFeEP/ThDBUjV/4vHVx6bVyfYMX6Q9PYhdV/CyJg7uthSIqIyzlNF65NVB1xwGtt0/' buildslave \
 && echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 440 /etc/sudoers.d/jenkins \
 && mkdir -p /var/run/sshd \
 && /usr/sbin/sshd
