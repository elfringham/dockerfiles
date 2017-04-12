#!/bin/sh

set -e

export LANG=C

image=linaro/ci-x86_64-jenkins-master-debian:lts
docker build --pull --tag=$image .
echo $image > .docker-tag
