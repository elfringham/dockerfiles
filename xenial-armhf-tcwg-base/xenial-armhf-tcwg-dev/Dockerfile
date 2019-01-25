# Auto generated from tcwg-base/tcwg-dev/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-base-ubuntu:xenial

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 apt-file \
 git-gui \
 git-svn \
 gnat-5 \
 less \
 locales \
 mc \
 screen \
 software-properties-common \
 stgit \
 tmux \
 && apt-get clean \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 \
 && apt-file update

# Create directories required for X11.
RUN mkdir -p /tmp/.X11-unix /tmp/.ICE-unix \
 && chmod 1777 /tmp/.X11-unix /tmp/.ICE-unix

COPY run.sh start.sh /

ENTRYPOINT ["linux32", "/run.sh"]
CMD ["start.sh"]
# checksum: b8cb9f0df64f714ab0d4514517850f35
