#!/bin/sh

set -e

image=linaro/gitlab-arm64

docker build --pull --tag=$image .
echo $image > .docker-tag
