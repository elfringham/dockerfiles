#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
  rm -rf tcwg-buildslave
}

export LANG=C

rsync -a ../tcwg-buildslave/ ./tcwg-buildslave/

docker build --pull --tag=linaro/$(basename ${PWD}) .
