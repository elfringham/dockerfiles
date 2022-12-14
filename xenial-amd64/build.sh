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

cp -a ../linaro-overlay-repo.list ../linaro-overlay-repo.key .
sed -e "s|@DISTRIBUTION@|${DISTRIBUTION}|" -i *.list

image=linaro/jenkins-${ARCHITECTURE}-ubuntu:${DISTRIBUTION}
docker build --pull --tag=$image .
echo $image > .docker-tag
