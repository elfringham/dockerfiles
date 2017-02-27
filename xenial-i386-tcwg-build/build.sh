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
image=linaro/ci-${arch}-${name}-ubuntu:${distro}

rsync -a ../tcwg-buildslave/ ./tcwg-buildslave/

(cd ../xenial-i386-tcwg-base; ./build.sh)
docker pull $image 2>/dev/null || true
docker build --tag=$image .
