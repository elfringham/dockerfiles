FROM linaro/ci-arm64-tcwg-ubuntu:trusty

COPY tcwg-buildslave/.ssh /root/.ssh

RUN chmod 0700 /root/.ssh/ \
 && sed -i -e "/.*PermitRootLogin.*/d" /etc/ssh/sshd_config \
 && echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
