# Auto generated from tcwg-base/tcwg-llvmbot/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-base-ubuntu:xenial

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
 && DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:ubuntu-toolchain-r/test \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 binutils-gold \
 buildbot \
 g++-9 \
 cpio \
 htop \
 iotop \
 libedit-dev \
 libjson-perl \
 libtinfo-dev \
 libxml2-dev \
 linux-tools-common \
 linux-tools-4.4.0-59-generic \
 python-sphinx \
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
 clang_ver=clang+llvm-8.0.1-armv7a-linux-gnueabihf \
 && cd /usr/local \
 && wget --progress=dot:giga https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/$clang_ver.tar.xz \
 && tar xf $clang_ver.tar.xz \
 && rm $clang_ver.tar.xz

VOLUME /home

COPY run.sh .
COPY start.sh .

ENTRYPOINT ["linux32", "/run.sh"]
CMD ["start.sh"]
# checksum: 1cbca28b11046dfaddc41f14b2de97df
