# Auto generated from tcwg-base/tcwg-llvmbot/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:focal

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
#linux-tools-NEED_TO_TEST \
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
 clang_ver=clang+llvm-6.0.0-aarch64-linux-gnu \
 && cd /usr/local \
 && wget --progress=dot:giga http://releases.llvm.org/6.0.0/$clang_ver.tar.xz \
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
# checksum: 08dc5618b274ac0188d092ad7e31f4b5
