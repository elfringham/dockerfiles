#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
  rm -f *.list *.key
}

export LANG=C

DISTRIBUTION=$(basename ${PWD} | cut -f1 -d '-')

cp -a ../linaro-*.list ../linaro-*.key .
sed -e "s|@DISTRIBUTION@|${DISTRIBUTION}|" -i *.list

# fixup - get rid of PPA usage
rm -f linaro-*ppa.*

image=$(basename ${PWD})
docker build --pull --tag=$image .
echo $image > .docker-tag
