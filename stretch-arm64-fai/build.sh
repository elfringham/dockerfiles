#!/bin/sh

set -e

export LANG=C

DISTRIBUTION=$(basename ${PWD} | cut -f1 -d '-')
ARCHITECTURE=$(basename ${PWD} | cut -f2 -d '-')
cp -a ../linaro-overlay-obs.list ../linaro-overlay-obs.key .

image=linaro/${ARCHITECTURE}-fai
docker build --pull --tag=$image .
echo $image > .docker-tag
