# Auto generated from tcwg-base/tcwg-build/Dockerfile.in. Do not edit.
FROM linaro/ci-i386-tcwg-base-ubuntu:trusty

RUN groupadd -g 9000 tcwg-infra \
 && useradd -m -g tcwg-infra -G kvm -u 11827 tcwg-buildslave \
 && useradd -m -g tcwg-infra -G kvm -u 12326 tcwg-benchmark \
 && echo '%tcwg-infra ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /home/tcwg-buildslave/workspace

COPY tcwg-buildslave /home/tcwg-buildslave
COPY tcwg-benchmark /home/tcwg-benchmark

RUN chown -R tcwg-buildslave:tcwg-infra /home/tcwg-buildslave/ \
 && chown -R tcwg-benchmark:tcwg-infra /home/tcwg-benchmark/ \
 && chmod 0700 /home/tcwg-buildslave/.ssh/ /home/tcwg-benchmark/.ssh/ \
 && chmod 0600 /home/tcwg-buildslave/.ssh/* /home/tcwg-benchmark/.ssh/*

# Install wine.  On amd64 arch we need to enable i386, otherwise wine
# won't meet dependencies (this is the case at least for trusty and xenial).
RUN \
 apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 wine \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*
# checksum: 50b70f6f0b7cf04d865d6a472c00f215
