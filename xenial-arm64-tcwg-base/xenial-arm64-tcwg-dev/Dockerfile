# Auto generated from tcwg-base/tcwg-dev/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:xenial

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 apt-file \
 git-gui \
 git-svn \
 gnat \
 less \
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

RUN apt-file update

# Create directories required for X11.
RUN mkdir -p /tmp/.X11-unix /tmp/.ICE-unix \
 && chmod 1777 /tmp/.X11-unix /tmp/.ICE-unix

COPY run.sh start.sh /

ENTRYPOINT ["/run.sh"]
CMD ["start.sh"]
# checksum: 3b6ab0d697af9634a392e9e8788d173b
