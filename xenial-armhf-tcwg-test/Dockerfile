FROM quay.io/fathi_boudra/ubuntu:xenial-armhf

COPY tcwg-buildslave/.ssh /etc/skel/.ssh
COPY tcwg-buildslave/.ssh /root/.ssh

RUN echo 'deb http://ports.ubuntu.com/ubuntu-ports xenial main universe' > /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 libtcnative-1 \
 openjdk-8-jdk \
 openssh-server \
 rsync \
 sudo \
 wget \
 xz-utils \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN chmod 0700 /etc/skel/.ssh \
 && groupadd -g 9000 tcwg-infra \
 && useradd -m -g tcwg-infra -u 11827 tcwg-buildslave \
 && rm -rf /etc/skel/.ssh \
 && echo 'tcwg-buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 440 /etc/sudoers.d/jenkins \
 && sed -i -e 's:^session *required *pam_loginuid.so:# session required pam_loginuid.so:' /etc/pam.d/sshd \
 && mkdir -p /var/run/sshd \
 && sed -i \
 -e "/.*MaxStartups.*/d" \
 -e "/.*MaxSesssions.*/d" \
 -e "/.*PermitRootLogin.*/d" /etc/ssh/sshd_config \
 && echo "MaxStartups 256" >> /etc/ssh/sshd_config \
 && echo "MaxSessions 256" >> /etc/ssh/sshd_config \
 && echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config

# Unfortunately, VOLUME doesn't support bind-mounts for portability reasons.
# Therefore, the bind-mounts for the following paths are configured in
# the ci.linaro.org's docker plugin.
# Jenkins .jar cache (read-write):
# /home/tcwg-buildslave/.jenkins:/home/tcwg-buildslave/.jenkins:rw

# We use ssh multiplexing, which creates sockets in /tmp.  Overlayfs,
# which docker is using can't host sockets, so we use a scratch mount
# for /tmp.  This requires that we add --rm option to "docker run"
# invocations (e.g., mark "Remove volumes" checkbox in docker plugin) to
# cleanup host directories used for the scratch mounts.
VOLUME /tmp

EXPOSE 22
CMD ["linux32", "/usr/sbin/sshd", "-D"]
