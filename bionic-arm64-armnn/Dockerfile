FROM linaro/jenkins-arm64-ubuntu:bionic

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 cmake \
 autoconf \
 automake \
 libtool \
 libpthread-stubs0-dev \
 python3-pip \
 virtualenv \
 python3-dev \
 libboost-dev \
 python3-setuptools \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ENV LC_ALL C.UTF-8

EXPOSE 22
ENTRYPOINT ["/usr/sbin/setup-sshd"]
