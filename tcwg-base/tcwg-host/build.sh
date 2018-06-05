#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
    rm -f authorized_keys-* passwd start.sh
}

export LANG=C
distro=$(basename ${PWD} | cut -f1 -d '-')
arch=$(basename ${PWD} | cut -f2 -d '-')
name=$(basename ${PWD} | cut -f3- -d '-')
image=linaro/ci-${arch}-${name}-ubuntu:${distro}
top=$(git rev-parse --show-toplevel)

cp $top/tcwg-base/tcwg-host/authorized_keys-* ./
cp $top/tcwg-base/tcwg-host/passwd ./
cp $top/tcwg-base/tcwg-host/start.sh ./

(cd ..; ./build.sh)
"$top"/tcwg-base/validate-dockerfile.sh Dockerfile
docker pull $image 2>/dev/null || true
docker build --tag=$image .
echo $image > .docker-tag
