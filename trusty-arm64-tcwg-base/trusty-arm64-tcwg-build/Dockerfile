# Auto generated from tcwg-base/tcwg-build/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:trusty

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

# checksum: 5904c80fcc6ea2a85a54d41f496a5f96
