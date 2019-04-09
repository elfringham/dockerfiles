#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
  rm -f *.list *.key
}

export LANG=C

DISTRIBUTION=$(basename ${PWD} | cut -f1 -d '-')
ARCHITECTURE=$(basename ${PWD} | cut -f2 -d '-')

cp -a ../linaro-overlay-obs.list ../linaro-overlay-obs.key .

image=linaro/ci-${ARCHITECTURE}-debian-lkft:${DISTRIBUTION}
docker build --pull --tag=$image .
echo $image > .docker-tag
