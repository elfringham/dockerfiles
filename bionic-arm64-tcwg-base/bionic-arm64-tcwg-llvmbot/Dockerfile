# Auto generated from tcwg-base/tcwg-llvmbot/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:bionic

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 binutils-gold \
 cpio \
 htop \
 iotop \
 libedit-dev \
 libjson-perl \
 libtinfo-dev \
 libxml2-dev \
 linux-tools-common \
 swig \
 tmux \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN new-user.sh --user tcwg-buildslave

# Add recent clang for libcxx bots. We use 8.0.1 because later versions require
# a more recent glibc than the one in Ubuntu 16.04.
RUN \
 clang_ver=clang+llvm-8.0.1-aarch64-linux-gnu \
 && cd /usr/local \
 && wget --progress=dot:giga https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/$clang_ver.tar.xz \
 && tar xf $clang_ver.tar.xz \
 && rm $clang_ver.tar.xz
# Install xenial's verion of buildbot
RUN \
 curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
 python2 ./get-pip.py && \
 pip2 install buildbot==0.8.12

VOLUME /home

COPY run.sh .
COPY start.sh .

ENTRYPOINT ["/run.sh"]
CMD ["start.sh"]
# checksum: cbf6b7657ffb6e2954bb7a9b85e82da5
