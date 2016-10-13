#!/bin/sh

set -e

export LANG=C

docker build --pull --tag=linaro/$(basename ${PWD}) .
