FROM ubuntu:bionic

COPY setup-sshd /usr/sbin/setup-sshd

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && echo y | unminimize \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y devscripts \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 bc \
 bison \
 ccache \
 build-essential \
 curl \
 flex \
 g++-multilib \
 gcc-multilib \
 git \
 gnupg \
 gperf \
 lib32ncurses5-dev \
 lib32z-dev \
 libc6-dev-i386 \
 libgl1-mesa-dev \
 libx11-dev \
 libxml2-utils \
 openjdk-8-jdk \
 openssh-server \
 parallel \
 python3-requests \
 rsync \
 unzip \
 x11proto-core-dev \
 xsltproc \
 xz-utils \
 zip \
 zlib1g-dev && \
 apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN useradd -m -G plugdev buildslave \
 && echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /var/run/sshd /home/buildslave/bin \
 && curl https://raw.githubusercontent.com/google/styleguide/gh-pages/cpplint/cpplint.py > /home/buildslave/bin/cpplint.py \
 && curl https://storage.googleapis.com/git-repo-downloads/repo > /home/buildslave/bin/repo \
 && chmod a+x /home/buildslave/bin/* \
 && chown -R buildslave:buildslave /home/buildslave/bin

ENV LC_ALL C.UTF-8

EXPOSE 22
ENTRYPOINT ["/usr/sbin/setup-sshd"]
