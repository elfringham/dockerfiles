#!/bin/sh

set -e

export LANG=C

for python_version in 3.7 3.8 3.9 3.10
do
docker build --pull \
        --build-arg PYTHON_VERSION=python${python_version} \
        --tag=linaro/tensorflow-build-aarch64:latest-python${python_version} .
done
