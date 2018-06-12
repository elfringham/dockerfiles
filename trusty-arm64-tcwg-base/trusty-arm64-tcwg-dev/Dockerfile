# Auto generated from tcwg-base/tcwg-dev/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:trusty

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
# checksum: 136835f5e64afb27c28164ca451962f4
