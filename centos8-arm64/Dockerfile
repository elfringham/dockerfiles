FROM centos:8

RUN dnf install -y openssh-server openssh-clients sudo wget python3-requests && \
    dnf groupinstall -y "Development Tools"

RUN useradd -m buildslave \
 && mkdir /home/buildslave/.ssh \
 && chown buildslave:buildslave /home/buildslave/.ssh \
 && chmod 700 /home/buildslave/.ssh \
 && echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && /usr/bin/ssh-keygen -A \
 && rm -rf /run/nologin

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
