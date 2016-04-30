FROM quay.io/fathi_boudra/centos:7-aarch64

RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 \
 && yum -y update \
 && yum --nogpgcheck --setopt=tsflags=nodocs -y install \
 alsa-lib-devel \
 ant \
 cups-devel \
 freetype-devel \
 gcc-c++ \
 git \
 java-1.8.0-openjdk \
 libX11-devel \
 libXext-devel \
 libXrender-devel \
 libXt-devel \
 libXtst-devel \
 mercurial \
 openssh-server \
 pkgconfig \
 xorg-x11-server-Xvfb \
 && rm -rf /var/cache/yum/*

RUN useradd buildslave \
 && echo 'buildslave ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && echo 'Defaults:buildslave !requiretty' >> /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /var/run/sshd \
 && /usr/sbin/sshd-keygen

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
