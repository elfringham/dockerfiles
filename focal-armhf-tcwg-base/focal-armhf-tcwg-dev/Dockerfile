# Auto generated by ./tcwg-base/generate-dockerfiles.sh from tcwg-base/tcwg-dev/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-base-ubuntu:focal
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 arcanist \
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
COPY run.sh start.sh /
ENTRYPOINT ["linux32", "/run.sh"]
CMD ["start.sh"]
# checksum: 09d0cf5e4e345f5a3c0f5defeb754130
