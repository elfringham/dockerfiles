#!/bin/sh

set -e

# Can't run multiple copies of this script
exec 9<Dockerfile
flock -x 9

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
    rm -rf docker-stats docker-wrapper run.sh start.sh
}

export LANG=C
distro=$(basename ${PWD} | cut -f1 -d '-')
arch=$(basename ${PWD} | cut -f2 -d '-')
name=$(basename ${PWD} | cut -f3- -d '-')
image=linaro/ci-${arch}-${name}-ubuntu:${distro}
top=$(git rev-parse --show-toplevel)

cp $top/tcwg-base/tcwg-host/docker-stats \
   $top/tcwg-base/tcwg-host/docker-wrapper \
   $top/tcwg-base/tcwg-host/run.sh \
   $top/tcwg-base/tcwg-host/start.sh ./

(cd ..; ./build.sh)
"$top"/tcwg-base/validate-dockerfile.sh Dockerfile
docker build --tag=$image .
echo $image > .docker-tag
