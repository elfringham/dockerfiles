FROM quay.io/fathi_boudra/centos:7-aarch64

RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 \
 && yum -y update \
 && yum --nogpgcheck --setopt=tsflags=nodocs -y install \
 ant \
 git \
 java-1.8.0-openjdk \
 mercurial \
 openssh-server \
 xorg-x11-server-Xvfb \
 && rm -rf /var/cache/yum/*

RUN useradd -p '$6$7tSX2YU5Q$ydZwAuWtNPPBb1Fv/tzy3eFeEP/ThDBUjV/4vHVx6bVyfYMX6Q9PYhdV/CyJg7uthSIqIyzlNF65NVB1xwGtt0/' buildslave \
 && echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /var/run/sshd \
 && /usr/sbin/sshd-keygen \
 && /usr/sbin/sshd

