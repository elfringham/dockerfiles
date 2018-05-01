#!/bin/sh

set -e

export LANG=C

image=linaro/ci-aarch64-leg-go-build-alpine
docker build --pull --tag=$image .
echo $image > .docker-tag
