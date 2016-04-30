FROM quay.io/fathi_boudra/ubuntu:trusty-arm64

RUN echo 'deb http://ports.ubuntu.com/ubuntu-ports trusty main universe' > /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y devscripts \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 ant \
 g++ \
 git \
 libasound2-dev \
 libcups2-dev \
 libfreetype6-dev \
 libx11-dev \
 libxext-dev \
 libxrender-dev \
 libxtst-dev \
 libxt-dev \
 mercurial \
 openjdk-7-jdk \
 openssh-server \
 pkg-config \
 sudo \
 wget \
 xvfb \
 zip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -m buildslave \
 && echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /var/run/sshd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
