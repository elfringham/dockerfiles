#!/bin/sh

set -e

# Can't run multiple copies of this script
exec 9<Dockerfile
flock -x 9

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
    rm -f start.sh run.sh
}

export LANG=C
distro=$(basename ${PWD} | cut -f1 -d '-')
arch=$(basename ${PWD} | cut -f2 -d '-')
name=$(basename ${PWD} | cut -f3- -d '-')
image=linaro/ci-${arch}-${name}-ubuntu:${distro}
top=$(git rev-parse --show-toplevel)

cp $top/tcwg-base/tcwg-dev/start.sh $top/tcwg-base/tcwg-dev/run.sh ./

(cd ..; ./build.sh)
"$top"/tcwg-base/validate-dockerfile.sh Dockerfile
docker pull $image 2>/dev/null || true
docker build --tag=$image .
echo $image > .docker-tag
