#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
  rm -f setup-sshd
}

export LANG=C

cp -a ../setup-sshd .

docker build --pull --tag=linaro/$(basename ${PWD}) .
