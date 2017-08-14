#!/bin/sh

set -e

export LANG=C

image=linaro/ci-aarch64-leg-microbot-alpine
docker build --pull --tag=$image .
echo $image > .docker-tag
