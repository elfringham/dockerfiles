# Auto generated from tcwg-base/tcwg-llvmbot/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-base-ubuntu:xenial

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 buildbot \
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

# Add ninja with support for memory-threshold job limitation.
RUN git clone -b master https://github.com/maxim-kuvyrkov/ninja.git \
 && cd ninja \
 && ./configure.py --bootstrap && ./ninja all && ./ninja_test \
 && mv ninja /usr/local/bin/ninja.bin \
 && cd .. \
 && rm -rf ninja

# Add current clang for benefit of libcxx bots.  LLD bot requires
# ld.lld symlink, which clang release happens to provide, but will work with
# symlinking ld.lld from ld.bfd just as well.
RUN \
 clang_ver=clang+llvm-5.0.1-armv7a-linux-gnueabihf \
 && cd /usr/local \
 && wget http://releases.llvm.org/5.0.1/$clang_ver.tar.xz \
 && tar -x --strip-components=1 -f $clang_ver.tar.xz \
 && rm $clang_ver.tar.xz

VOLUME /home

COPY run.sh .
COPY start.sh .

ENTRYPOINT ["linux32", "/run.sh"]
CMD ["start.sh"]
# checksum: 000f6c3ec143b2a7d51a8ae645dbc466
