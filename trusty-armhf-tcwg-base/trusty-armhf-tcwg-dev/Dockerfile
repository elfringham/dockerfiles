FROM linaro/ci-armhf-tcwg-base-ubuntu:trusty

COPY run.sh .
COPY start.sh .

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 software-properties-common \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 apt-file \
 git-gui \
 git-review \
 git-svn \
 less \
 libgmp-dev \
 libmpc-dev \
 libmpfr-dev \
 mc \
 screen \
 stgit \
 tmux \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN sed -i -e '/.*AuthorizedKeysFile/ d' /etc/ssh/sshd_config \
 && echo "AuthorizedKeysFile %h/.ssh/authorized_keys.docker" >> /etc/ssh/sshd_config \
 && locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 \
 && apt-file update

# Create directories required for X11.
RUN mkdir -p /tmp/.X11-unix /tmp/.ICE-unix \
 && chmod 1777 /tmp/.X11-unix /tmp/.ICE-unix

ENTRYPOINT ["linux32", "/run.sh"]
CMD ["start.sh"]
