FROM centos:7

RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 \
 && yum -y update \
 && yum --nogpgcheck --setopt=tsflags=nodocs -y install \
 git \
 java-1.8.0-openjdk \
 make \
 openssh-server \
 openssh \
 rpm-build \
 wget \
 yum-utils \
 gcc \
 glibc-devel \
 git \
 dejagnu \
 texinfo \
 gcc-c++ \
 autoconf \
 libtool \
 automake \
 autogen \
 wget \
 flex \
 bison \
 gawk \
 lsb-build-cc \
 lsb-build-c++ \
 python-devel \
 ncurses-devel \
 sudo \
 && rm -rf /var/cache/yum/*

RUN useradd buildslave \
 && groupadd -g 9000 tcwg-infra \
 && useradd -m -g tcwg-infra -u 11827 tcwg-buildslave \
 && echo 'tcwg-buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && touch /home/tcwg-buildslave/.profile \
 && echo 'PATH="/opt/lsb/bin:$PATH"' >> /home/tcwg-buildslave/.profile \
 && sed -i -e 's:^session *required *pam_loginuid.so:# session required pam_loginuid.so:' /etc/pam.d/sshd \
 && mkdir -p /var/run/sshd 
# && /usr/bin/ssh-keygen

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
