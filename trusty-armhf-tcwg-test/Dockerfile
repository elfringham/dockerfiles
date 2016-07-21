FROM quay.io/fathi_boudra/ubuntu:trusty-armhf

COPY *.list *.key /etc/apt/sources.list.d/

RUN echo 'deb http://ports.ubuntu.com/ubuntu-ports trusty main universe' > /etc/apt/sources.list \
 && apt-key add /etc/apt/sources.list.d/*.key \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 openssh-server \
 rsync \
 sudo \
 wget \
 xz-utils \
 && apt-get clean \
 && rm -rf \
 /etc/apt/sources.list.d/*.key \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN groupadd -g 9000 tcwg-infra \
 && useradd -m -g tcwg-infra -u 11827 tcwg-buildslave \
 && echo 'tcwg-buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 440 /etc/sudoers.d/jenkins \
 && sed -i -e 's:^session *required *pam_loginuid.so:# session required pam_loginuid.so:' /etc/pam.d/sshd \
 && mkdir -p /var/run/sshd

# Increase the limit for concurrent connections and for connection sharing,
# and enable root login.
RUN sed -i \
	-e "/.*MaxStartups.*/d" \
	-e "/.*MaxSesssions.*/d" \
	-e "/.*PermitRootLogin.*/d" /etc/ssh/sshd_config \
 && echo "MaxStartups 256" >> /etc/ssh/sshd_config \
 && echo "MaxSessions 256" >> /etc/ssh/sshd_config \
 && echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

COPY tcwg-buildslave/.ssh /root/.ssh
COPY tcwg-buildslave/.ssh /home/tcwg-buildslave/.ssh
RUN chown -R tcwg-buildslave:tcwg-infra /home/tcwg-buildslave/.ssh/

# We use ssh multiplexing, which creates sockets in /tmp.  Overlayfs,
# which docker is using can't host sockets, so we use a scratch mount
# for /tmp.  This requires that we add --rm option to "docker run"
# invocations (e.g., mark "Remove volumes" checkbox in docker plugin) to
# cleanup host directories used for the scratch mounts.
VOLUME /tmp
