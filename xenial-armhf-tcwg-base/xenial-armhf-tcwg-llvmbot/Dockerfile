# Auto generated from tcwg-base/tcwg-llvmbot/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-base-ubuntu:xenial

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
 && DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:ubuntu-toolchain-r/test \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 buildbot \
 g++-9 \
# Workaround tzdata not being updated in tcwg-base image.
 && DEBIAN_FRONTEND=noninteractive apt-get install --reinstall tzdata \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

COPY buildslave/ llvm-config-buildslave/
RUN cd ./llvm-config-buildslave/ \
 && HOME=$(pwd) ./llvm-setup \
 && ./cleanup-users \
 && cd ../.. \
 && rm -rf \
 llvm-config-buildslave/ \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/* \
 && sudo -i -u buildslave mkdir /home/buildslave/buildslave

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
# checksum: d08c833045de954ed42d0e9e7864f4f9
