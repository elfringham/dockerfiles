#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
  rm -rf tcwg-buildslave tcwg-benchmark
}

export LANG=C
distro=$(basename ${PWD} | cut -f1 -d '-')
arch=$(basename ${PWD} | cut -f2 -d '-')
name=$(basename ${PWD} | cut -f3- -d '-')
image=linaro/ci-${arch}-${name}-ubuntu:${distro}
top=$(git rev-parse --show-toplevel)

rsync -a $top/tcwg-base/tcwg-build/tcwg-buildslave/ ./tcwg-buildslave/
rsync -a $top/tcwg-base/tcwg-build/tcwg-benchmark/ ./tcwg-benchmark/

(cd ..; ./build.sh)
docker pull $image 2>/dev/null || true
docker build --tag=$image .
echo $image > .docker-tag
