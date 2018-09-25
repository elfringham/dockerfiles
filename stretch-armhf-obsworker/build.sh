#!/bin/sh

set -e

export LANG=C

DISTRIBUTION=$(basename ${PWD} | cut -f1 -d '-')
ARCHITECTURE=$(basename ${PWD} | cut -f2 -d '-')

image=linaro/ci-${ARCHITECTURE}-obsworker
docker build --pull --tag=$image .
echo $image > .docker-tag
