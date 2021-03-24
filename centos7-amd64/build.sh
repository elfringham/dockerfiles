#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
  rm -f setup-sshd
}

export LANG=C

cp -a ../setup-sshd .

image=linaro/jenkins-amd64-centos:7
docker build --pull --tag=$image .
echo $image > .docker-tag
