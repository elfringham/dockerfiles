# Auto generated from tcwg-base/tcwg-llvmbot/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-base-ubuntu:bionic

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

# Add a recent clang for libcxx bots, because they build and test the libraries
# using the latest C++ standard, which might not be supported by the system
# compiler.
RUN \
 clang_ver=clang+llvm-10.0.1-armv7a-linux-gnueabihf \
 && cd /usr/local \
 && wget --progress=dot:giga https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/$clang_ver.tar.xz \
 && tar xf $clang_ver.tar.xz \
 && rm $clang_ver.tar.xz

VOLUME /home

COPY run.sh .
COPY start.sh .

ENTRYPOINT ["linux32", "/run.sh"]
CMD ["start.sh"]
# checksum: 97c234ef90a727b1f0a6abad1a311b39
