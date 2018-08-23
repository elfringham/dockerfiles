#!/bin/sh

set -e

export LANG=C

if [ -z "$1" ]; then
    echo "Usage: ./build.sh <git_tag>"
    tag="$(git ls-remote https://git.linaro.org/qa/test-definitions.git refs/heads/master | cut -c1-7)"
    echo "Warning: git tag not specified, latest commit (${tag}) on master branch is used."
else
    tag="$1"
    sed -i "s/git checkout master/git checkout ${tag} -b ${tag}/" Dockerfile
fi

DISTRIBUTION="$(basename "${PWD}" | cut -f1 -d '-')"
ARCHITECTURE="$(basename "${PWD}" | cut -f2 -d '-')"

image=linaro/testdef-${ARCHITECTURE}-debian-${DISTRIBUTION}:${tag}
docker build --pull --tag="$image" .
echo "$image" > .docker-tag
