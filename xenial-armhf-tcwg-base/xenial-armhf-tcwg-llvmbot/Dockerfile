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
 swig \
 tmux \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN new-user.sh --user tcwg-buildslave

# Add current clang for libcxx bots.
RUN \
 clang_ver=clang+llvm-6.0.0-armv7a-linux-gnueabihf \
 && cd /usr/local \
 && wget --progress=dot:giga http://releases.llvm.org/6.0.0/$clang_ver.tar.xz \
 && tar xf $clang_ver.tar.xz \
 && rm $clang_ver.tar.xz

VOLUME /home

COPY run.sh .
COPY start.sh .

ENTRYPOINT ["linux32", "/run.sh"]
CMD ["start.sh"]
# checksum: 3570e3f0445dd17afa5eaf20e89c4a3b
