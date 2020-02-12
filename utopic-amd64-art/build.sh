#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
  rm -f setup-sshd
}

export LANG=C

DISTRIBUTION=$(basename ${PWD} | cut -f1 -d '-')
ARCHITECTURE=$(basename ${PWD} | cut -f2 -d '-')

cp -a ../setup-sshd .

image=linaro/jenkins-${ARCHITECTURE}-art-ubuntu:${DISTRIBUTION}
docker build --pull --tag=$image .
echo $image > .docker-tag
