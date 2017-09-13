# Auto generated from tcwg-base/tcwg-build/tcwg-test/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-build-ubuntu:zesty

COPY tcwg-buildslave/.ssh /root/.ssh

RUN chmod 0700 /root/.ssh/ \
 && sed -i -e "/.*PermitRootLogin.*/d" /etc/ssh/sshd_config \
 && echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
# checksum: 97645d9dd266629322e5413847db65e6
