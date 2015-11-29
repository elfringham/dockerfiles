#!/bin/sh

set -e

export LANG=C

docker build --tag=linaro/$(basename ${PWD}) .
