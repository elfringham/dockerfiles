FROM quay.io/fathi_boudra/fedora:23-aarch64

RUN dnf -y update \
 && dnf --nogpgcheck --setopt=tsflags=nodocs -y install \
 git \
 java-1.8.0-openjdk \
 openssh-server \
 && rm -rf /var/cache/dnf/* /var/cache/yum/*

RUN useradd -p '$6$7tSX2YU5Q$ydZwAuWtNPPBb1Fv/tzy3eFeEP/ThDBUjV/4vHVx6bVyfYMX6Q9PYhdV/CyJg7uthSIqIyzlNF65NVB1xwGtt0/' buildslave \
 && echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /var/run/sshd \
 && /usr/sbin/sshd-keygen

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
