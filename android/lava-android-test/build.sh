#!/bin/bash -ex

image=linaro/lava-android-test:latest
docker build --pull --tag ${image} -f Dockerfile .
echo $image > .docker-tag
