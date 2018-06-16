# Auto generated from tcwg-base/tcwg-dev/Dockerfile.in. Do not edit.
FROM linaro/ci-amd64-tcwg-base-ubuntu:bionic

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
 git-svn \
 gnat-5 \
 less \
 locales \
 libgmp-dev \
 libmpc-dev \
 libmpfr-dev \
 mc \
 screen \
 stgit \
 tmux \
 unifdef \
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

ENTRYPOINT ["/run.sh"]
CMD ["start.sh"]
# checksum: 286aa782c315c534aeae4e1fef031429
