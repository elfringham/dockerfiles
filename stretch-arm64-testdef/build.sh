#!/bin/sh

set -e

export LANG=C

DISTRIBUTION=$(basename ${PWD} | cut -f1 -d '-')
ARCHITECTURE=$(basename ${PWD} | cut -f2 -d '-')
COMMIT_HASH=$(git ls-remote --heads https://git.linaro.org/qa/test-definitions.git | grep master | cut -c1-7)

image=linaro/testdef-${ARCHITECTURE}-debian-${DISTRIBUTION}:${COMMIT_HASH}
docker build --pull --tag=$image .
echo $image > .docker-tag
