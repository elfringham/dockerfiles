#!/bin/sh

set -e

export LANG=C

image=linaro/ci-aarch64-leg-nginx-alpine:3.5
docker build --pull --tag=$image .
echo $image > .docker-tag
