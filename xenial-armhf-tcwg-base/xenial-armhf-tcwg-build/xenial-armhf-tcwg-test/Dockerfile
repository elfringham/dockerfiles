# Auto generated from tcwg-base/tcwg-build/tcwg-test/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-build-ubuntu:xenial

COPY tcwg-buildslave/.ssh /root/.ssh

RUN chmod 0700 /root/.ssh/ \
 && sed -i -e "/.*PermitRootLogin.*/d" /etc/ssh/sshd_config \
 && echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
# checksum: 3f70f196ffb86f43cdc7369b271c8c1d
