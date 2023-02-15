#!/bin/sh

set -e

export LANG=C

release_tag=2.12

for python_version in 3.8 3.9 3.10 3.11
do
docker build --pull \
        --build-arg PYTHON_VERSION=python${python_version} \
        --tag=linaro/tensorflow-arm64-build:latest-python${python_version} \
        --tag=linaro/tensorflow-arm64-build:${release_tag}-python${python_version} .
mkdir -p tagdir-python${python_version}
echo linaro/tensorflow-arm64-build:latest-python${python_version} > tagdir-python${python_version}/.docker-tag
mkdir -p tagdir-${release_tag}-python${python_version}
echo linaro/tensorflow-arm64-build:${release_tag}-python${python_version} > tagdir-${release_tag}-python${python_version}/.docker-tag
done
