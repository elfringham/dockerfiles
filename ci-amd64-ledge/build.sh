#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
  rm -f setup-sshd
}

export LANG=C

image=linaro/ci-amd64-ledge:stable
docker build --pull --tag=$image .
echo $image > .docker-tag
