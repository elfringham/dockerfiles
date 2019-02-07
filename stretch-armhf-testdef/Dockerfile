FROM linaro/ci-armhf-debian:stretch

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 python-pip \
 && git clone http://git.linaro.org/qa/test-definitions.git \
 && cd test-definitions \
 && git checkout master \
 && pip install -r automated/utils/requirements.txt \
 && apt-get clean \
 && rm -rf \
 /tmp/* \
 /var/tmp/*

ENV REPO_PATH=/test-definitions \
 PATH="/test-definitions/automated/bin:${PATH}"

WORKDIR /test-definitions
