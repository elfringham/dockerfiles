#!/bin/sh

set -e

export LANG=C

image=linaro/ci-amd64-llp-alpine:latest
docker build --pull --tag=$image .
echo $image > .docker-tag
