#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
  rm -f linaro.list linarorepo.key
}

export LANG=C

DISTRIBUTION=$(basename ${PWD} | cut -f1 -d '-')

cp -a ../${DISTRIBUTION}.list linaro.list
cp -a ../linarorepo.key . 

docker build --tag=linaro/$(basename ${PWD}) .
