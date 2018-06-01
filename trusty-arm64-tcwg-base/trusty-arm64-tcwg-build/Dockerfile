# Auto generated from tcwg-base/tcwg-build/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:trusty

COPY new-user.sh /usr/local/bin/

RUN new-user.sh --group tcwg-infra:9000 \
 && new-user.sh --passwd "tcwg-buildslave:x:11827:9000:TCWG Buildslave::/bin/bash" \
 && new-user.sh --passwd "tcwg-benchmark:x:12326:9000:TCWG Benchmark::/bin/bash" \
 && mkdir -p /home/tcwg-buildslave/workspace

COPY tcwg-buildslave /home/tcwg-buildslave
COPY tcwg-benchmark /home/tcwg-benchmark

RUN chown -R tcwg-buildslave:tcwg-infra /home/tcwg-buildslave/ \
 && chown -R tcwg-benchmark:tcwg-infra /home/tcwg-benchmark/ \
 && chmod 0700 /home/tcwg-buildslave/.ssh/ /home/tcwg-benchmark/.ssh/ \
 && chmod 0600 /home/tcwg-buildslave/.ssh/* /home/tcwg-benchmark/.ssh/*

# checksum: 80c0646d8f957e1f33fd66f3c2c29e48
