# Auto generated from tcwg-base/tcwg-build/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:trusty

COPY new-user.sh /usr/local/bin/

RUN new-user.sh --user tcwg-buildslave:11827 --group tcwg-infra:9000 \
 && new-user.sh --user tcwg-benchmark:12326 --group tcwg-infra \
 && mkdir -p /home/tcwg-buildslave/workspace

COPY tcwg-buildslave /home/tcwg-buildslave
COPY tcwg-benchmark /home/tcwg-benchmark

RUN chown -R tcwg-buildslave:tcwg-infra /home/tcwg-buildslave/ \
 && chown -R tcwg-benchmark:tcwg-infra /home/tcwg-benchmark/ \
 && chmod 0700 /home/tcwg-buildslave/.ssh/ /home/tcwg-benchmark/.ssh/ \
 && chmod 0600 /home/tcwg-buildslave/.ssh/* /home/tcwg-benchmark/.ssh/*

# checksum: d46dab616715909f84717ae49d7542b9
