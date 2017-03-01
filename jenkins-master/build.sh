#!/bin/sh

set -e

export LANG=C

docker build --pull --tag=linaro/ci-x86_64-jenkins-master-alpine:lts .
