# Auto generated from tcwg-base/tcwg-llvmbot/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:focal

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 binutils-gold \
 buildbot \
 cpio \
 htop \
 iotop \
 libedit-dev \
 libjson-perl \
 libtinfo-dev \
 libxml2-dev \
 python-sphinx \
 swig \
 tmux \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN new-user.sh --user tcwg-buildslave \
 && sudo -i -u tcwg-buildslave mkdir /home/tcwg-buildslave/buildslave

# Add current clang for libcxx bots.
RUN \
 clang_ver=clang+llvm-6.0.0-aarch64-linux-gnu \
 && cd /usr/local \
 && wget --progress=dot:giga http://releases.llvm.org/6.0.0/$clang_ver.tar.xz \
 && tar xf $clang_ver.tar.xz \
 && rm $clang_ver.tar.xz

VOLUME /home

COPY run.sh .
COPY start.sh .

ENTRYPOINT ["/run.sh"]
CMD ["start.sh"]
# checksum: eb9ef5f6df693160c6b7d35008e066df
