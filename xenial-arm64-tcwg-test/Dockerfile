FROM linaro/ci-arm64-tcwg-build-ubuntu:xenial

COPY tcwg-buildslave/.ssh /root/.ssh

RUN sed -i \
 -e "/.*PermitRootLogin.*/d" /etc/ssh/sshd_config \
 && echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
