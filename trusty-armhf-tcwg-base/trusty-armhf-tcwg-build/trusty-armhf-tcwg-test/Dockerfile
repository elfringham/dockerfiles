# Auto generated from tcwg-base/tcwg-build/tcwg-test/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-build-ubuntu:trusty

COPY tcwg-buildslave/.ssh /root/.ssh

RUN chmod 0700 /root/.ssh/ \
 && sed -i -e "/.*PermitRootLogin.*/d" /etc/ssh/sshd_config \
 && echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
# checksum: 9583d23d885b59e3b3a3f2e6b3e44c38
