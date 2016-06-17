FROM docker.io/saltstack/opensuse-13.2-minimal

RUN zypper update \
 && zypper -n install \
 git \
 gcc \
 gcc-c++ \
 autoconf \
 libtool \
 automake \
 autogen \
 texinfo \
 python-devel \
 ncurses-devel \
 flex \
 bison

RUN useradd buildslave \
 && groupadd -g 9000 tcwg-infra \
 && useradd -m -g tcwg-infra -u 11827 tcwg-buildslave 

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
