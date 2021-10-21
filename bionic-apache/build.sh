#!/bin/sh

set -e

export LANG=C

image=linaro/apache:bionic
docker build --pull --tag=$image .
echo $image > .docker-tag
