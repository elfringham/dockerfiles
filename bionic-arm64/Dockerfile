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
 clang-4.0 \
 clang-format-4.0 \
 clang-tidy-4.0 \
 curl \
 flex \
 git \
 gnupg \
 gperf \
 lava-tool \
 libgl1-mesa-dev \
 libx11-dev \
 libxml2-utils \
 openjdk-11-jdk \
 openssh-server \
 parallel \
 python-cryptography \
 python-mako \
 python-networkx \
 python-pip \
 python-requests \
 python-wheel \
 python3-cryptography \
 python3-pip \
 python3-requests \
 python3-wheel \
 qemu-user-static \
 rsync \
 scons \
 sudo \
 unzip \
 x11proto-core-dev \
 xsltproc \
 xz-utils \
 wget \
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

RUN pip install jenkins-job-builder==2.10.0 \
 && git clone --depth 1 https://git.linaro.org/infrastructure/jjb-linaro-plugin.git \
 && cd jjb-linaro-plugin && python setup.py install && cd .. && rm -rf jjb-linaro-plugin

ENV LC_ALL C.UTF-8

EXPOSE 22
ENTRYPOINT ["/usr/sbin/setup-sshd"]

