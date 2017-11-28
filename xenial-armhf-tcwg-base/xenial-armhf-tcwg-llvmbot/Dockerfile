# Auto generated from tcwg-base/tcwg-llvmbot/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-base-ubuntu:xenial

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 buildbot \
 python-psutil \
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

# Replace ninja with a one that supports memory-threshold job limitation.
# When running with "-m 50" ninja will not start new jobs if system memory
# utilization is beyond 50%.
RUN apt-get remove -y ninja-build \
 && git clone -b master https://github.com/maxim-kuvyrkov/ninja.git \
 && cd ninja \
 && ./configure.py --bootstrap && ./ninja all && ./ninja_test \
 && mv ninja /usr/local/bin/ninja.bin \
 && echo '#!/bin/sh' > /usr/local/bin/ninja \
 && echo '/usr/local/bin/ninja.bin -m 50 -M 50 -D 5000  "$@"' >> /usr/local/bin/ninja \
 && chmod +x /usr/local/bin/ninja \
 && cd .. \
 && rm -rf ninja

VOLUME /home/buildslave/buildslave

COPY run.sh .
COPY start.sh .

ENTRYPOINT ["linux32", "/run.sh"]
CMD ["start.sh"]
# checksum: de1960303fa880eeead54d7b6742eace
