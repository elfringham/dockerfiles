#!/bin/sh

set -e

export LANG=C

ARCHITECTURE=$(basename ${PWD} | cut -f2 -d '-')

image=linaro/ci-${ARCHITECTURE}-centos:7
docker build --pull --tag=$image .
echo $image > .docker-tag
