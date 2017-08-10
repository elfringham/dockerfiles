#!/bin/sh

set -e

export LANG=C

image=linaro/ci-aarch64-leg-etcd
docker build --pull --tag=$image .
echo $image > .docker-tag
