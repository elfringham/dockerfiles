# Auto generated from tcwg-base/tcwg-build/tcwg-test/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-build-ubuntu:zesty

COPY tcwg-buildslave/.ssh /root/.ssh

RUN chmod 0700 /root/.ssh/ \
 && sed -i -e "/.*PermitRootLogin.*/d" /etc/ssh/sshd_config \
 && echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
# checksum: 55db116aeb8f6c31fb8ef4187b1ee250
