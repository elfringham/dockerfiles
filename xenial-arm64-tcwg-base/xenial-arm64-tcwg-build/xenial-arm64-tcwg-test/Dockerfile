# Auto generated from tcwg-base/tcwg-build/tcwg-test/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-build-ubuntu:xenial

COPY tcwg-buildslave/.ssh /root/.ssh

RUN chmod 0700 /root/.ssh/ \
 && sed -i -e "/.*PermitRootLogin.*/d" /etc/ssh/sshd_config \
 && echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
# checksum: 9d6f202aa1c9a2f4391cb0687d75c45a
