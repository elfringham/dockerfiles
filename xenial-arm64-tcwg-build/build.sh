#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
  rm -rf tcwg-buildslave
}

export LANG=C
distro=$(basename ${PWD} | cut -f1 -d '-')
arch=$(basename ${PWD} | cut -f2 -d '-')
name=$(basename ${PWD} | cut -f3- -d '-')

rsync -a ../tcwg-buildslave/ ./tcwg-buildslave/

docker build --pull --tag=linaro/ci-${arch}-${name}-ubuntu:${distro} .
