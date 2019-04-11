FROM centos:7

ENV container docker

RUN yum -y update \
 && yum --nogpgcheck --setopt=tsflags=nodocs -y install \
 git \
 java-1.8.0-openjdk \
 make \
 openssh-server \
 python-requests \
 rpm-build \
 virt-install \
 wget \
 yum-utils \
 && yum clean all \
 && rm -rf /var/cache/yum/*

RUN useradd buildslave \
 && echo 'buildslave ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && echo 'Defaults:buildslave !requiretty' >> /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /var/run/sshd \
 && /usr/sbin/sshd-keygen

VOLUME ["/var/lib/libvirt"]

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
