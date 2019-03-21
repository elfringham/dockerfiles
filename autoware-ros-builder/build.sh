#!/bin/sh

set -e

export LANG=C

image=linaro/ci-ros-builder:kinetic
docker build --pull --tag=$image .
echo $image > .docker-tag
