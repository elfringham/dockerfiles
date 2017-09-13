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

VOLUME /home/buildslave/buildslave

COPY run.sh .
COPY start.sh .

ENTRYPOINT ["linux32", "/run.sh"]
CMD ["start.sh"]
# checksum: d99498f2fd3cc3b07ea0afc9fb073df2
