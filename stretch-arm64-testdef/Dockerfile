FROM linaro/ci-arm64-debian:stretch

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 python-pip \
 && git clone -b master http://git.linaro.org/qa/test-definitions.git \
 && cd test-definitions \
 && pip install -r automated/utils/requirements.txt \
 && apt-get clean \
 && rm -rf \
 /tmp/* \
 /var/tmp/*

ENV REPO_PATH=/test-definitions \
 PATH="/test-definitions/automated/bin:${PATH}"

WORKDIR /test-definitions
