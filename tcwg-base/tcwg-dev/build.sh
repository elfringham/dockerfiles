#!/bin/sh

set -e

# Can't run multiple copies of this script
exec 9<Dockerfile
flock -x 9

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
    rm -f start.sh run.sh nvidia-power-cycle.sh nvidia-serial.sh
}

export LANG=C
distro=$(basename ${PWD} | cut -f1 -d '-')
arch=$(basename ${PWD} | cut -f2 -d '-')
name=$(basename ${PWD} | cut -f3- -d '-')
image=linaro/ci-${arch}-${name}-ubuntu:${distro}
top=$(git rev-parse --show-toplevel)

cp $top/tcwg-base/tcwg-dev/start.sh $top/tcwg-base/tcwg-dev/run.sh \
   $top/tcwg-base/tcwg-dev/nvidia-power-cycle.sh \
   $top/tcwg-base/tcwg-dev/nvidia-serial.sh \
   ./

(cd ..; ./build.sh)
"$top"/tcwg-base/validate-checksum.sh Dockerfile
docker build --tag=$image .
echo $image > .docker-tag
