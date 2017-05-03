#!/bin/sh

set -e

export LANG=C

image=linaro/$(basename ${PWD})
docker build --pull --tag=$image .
echo $image > .docker-tag
