#!/bin/sh

set -e

export LANG=C

image=$(basename ${PWD})
docker build --pull --tag=linaro/$image .
echo $image > .docker-tag
