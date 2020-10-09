# Auto generated from tcwg-base/tcwg-llvmbot/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:bionic

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 binutils-gold \
 cpio \
 g++-8 \
 htop \
 iotop \
 libedit-dev \
 libjson-perl \
 libtinfo-dev \
 libxml2-dev \
 linux-tools-common \
 python3-buildbot-worker \
 tmux \
 && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 \
 --slave /usr/bin/g++ g++ /usr/bin/g++-8 \
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

VOLUME /home

COPY run.sh .
COPY start.sh .

ENTRYPOINT ["/run.sh"]
CMD ["start.sh"]
# checksum: bb6df7d004310fac4a2ec8e6e5eaec6e
