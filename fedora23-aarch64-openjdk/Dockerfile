FROM quay.io/fathi_boudra/fedora:23-aarch64

RUN dnf -y update \
 && dnf --nogpgcheck --setopt=tsflags=nodocs -y install \
 alsa-lib-devel \
 ant \
 cups-devel \
 freetype-devel \
 gcc-c++ \
 git \
 java-1.8.0-openjdk \
 mercurial \
 libX11-devel \
 libXext-devel \
 libXrender-devel \
 libXt-devel \
 libXtst-devel \
 openssh-server \
 pkgconfig \
 xorg-x11-server-Xvfb \
 && rm -rf /var/cache/dnf/* /var/cache/yum/*

RUN useradd buildslave \
 && echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /var/run/sshd \
 && /usr/sbin/sshd-keygen

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
