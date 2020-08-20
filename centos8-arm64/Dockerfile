FROM centos:8

RUN dnf install -y openssh-server openssh-clients sudo && \
    dnf groupinstall -y "Development Tools"

RUN echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
