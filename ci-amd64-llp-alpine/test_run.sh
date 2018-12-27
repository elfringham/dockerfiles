#!/bin/bash

REPO=/tmp/test-llp-root

mkdir -p $REPO/test-llp.linaro.org
test \! -d $REPO/linaro-license-protection && (cd $REPO; git clone https://git.linaro.org/infrastructure/linaro-license-protection.git)

docker run --name test-llp --rm -p 8080:8080 -v $REPO/test-llp.linaro.org:/srv -v $REPO/linaro-license-protection:/srv/linaro-license-protection linaro/ci-amd64-llp-alpine
