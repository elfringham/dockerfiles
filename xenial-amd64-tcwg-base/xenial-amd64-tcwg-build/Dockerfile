# Auto generated from tcwg-base/tcwg-build/Dockerfile.in. Do not edit.
FROM linaro/ci-amd64-tcwg-base-ubuntu:xenial

RUN groupadd -g 9000 tcwg-infra \
 && useradd -m -g tcwg-infra -G kvm -u 11827 tcwg-buildslave \
 && echo 'tcwg-buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /home/tcwg-buildslave/workspace

COPY tcwg-buildslave /home/tcwg-buildslave
RUN chown -R tcwg-buildslave:tcwg-infra /home/tcwg-buildslave/ \
 && chmod 0700 /home/tcwg-buildslave/.ssh/
# checksum: 5a86865cb900e6ec527306f7cb558280
