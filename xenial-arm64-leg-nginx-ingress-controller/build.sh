#!/bin/sh

set -e

image=linaro/ci-arm64-leg-nginx-ingress-controller-ubuntu:xenial
docker build --pull --tag=$image .
echo $image > .docker-tag
