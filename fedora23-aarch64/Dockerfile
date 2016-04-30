FROM quay.io/fathi_boudra/fedora:23-aarch64

RUN dnf -y update \
 && dnf --nogpgcheck --setopt=tsflags=nodocs -y install \
 git \
 java-1.8.0-openjdk \
 openssh-server \
 && rm -rf /var/cache/dnf/* /var/cache/yum/*

RUN useradd buildslave \
 && echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /var/run/sshd \
 && /usr/sbin/sshd-keygen

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
