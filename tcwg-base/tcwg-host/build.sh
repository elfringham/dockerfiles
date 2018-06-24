#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
    rm -rf docker-wrapper run.sh start.sh
}

export LANG=C
distro=$(basename ${PWD} | cut -f1 -d '-')
arch=$(basename ${PWD} | cut -f2 -d '-')
name=$(basename ${PWD} | cut -f3- -d '-')
image=linaro/ci-${arch}-${name}-ubuntu:${distro}
top=$(git rev-parse --show-toplevel)

cp $top/tcwg-base/tcwg-host/docker-wrapper \
   $top/tcwg-base/tcwg-host/run.sh \
   $top/tcwg-base/tcwg-host/start.sh ./

(cd ..; ./build.sh)
"$top"/tcwg-base/validate-dockerfile.sh Dockerfile
docker pull $image 2>/dev/null || true
docker build --tag=$image .
echo $image > .docker-tag
