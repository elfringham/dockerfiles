#!/bin/sh

set -e

# Can't run multiple copies of this script
exec 9<Dockerfile
flock -x 9

export LANG=C
distro=$(basename ${PWD} | cut -f1 -d '-')
arch=$(basename ${PWD} | cut -f2 -d '-')
name=$(basename ${PWD} | cut -f3- -d '-')
image=linaro/ci-${arch}-${name}-ubuntu:${distro}
top=$(git rev-parse --show-toplevel)

# Pull parent image instead of rebuilding it
docker pull linaro/ci-${arch}-tcwg-dev-ubuntu:${distro}
"$top"/tcwg-base/validate-checksum.sh Dockerfile
docker build --tag=$image .
echo $image > .docker-tag
