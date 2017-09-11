# Auto generated from tcwg-base/tcwg-build/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-base-ubuntu:trusty

RUN groupadd -g 9000 tcwg-infra \
 && useradd -m -g tcwg-infra -G kvm -u 11827 tcwg-buildslave \
 && echo 'tcwg-buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /home/tcwg-buildslave/workspace

COPY tcwg-buildslave /home/tcwg-buildslave
RUN chown -R tcwg-buildslave:tcwg-infra /home/tcwg-buildslave/ \
 && chmod 0700 /home/tcwg-buildslave/.ssh/
# checksum: 86a4af35e82d1ea8241e260a8cec4d16
