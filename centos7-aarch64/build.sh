#!/bin/sh

set -e

export LANG=C

ARCHITECTURE=$(basename ${PWD} | cut -f2 -d '-')

docker build --pull --tag=linaro/ci-${ARCHITECTURE}-centos:7 .
