#!/bin/sh

set -e

export LANG=C

DISTRIBUTION=$(basename ${PWD} | cut -f1 -d '-')
ARCHITECTURE=$(basename ${PWD} | cut -f2 -d '-')
REPO=$(basename $(dirname ${PWD}))

# Get version by parsing Packages file from respective repo.
VERSION=$(wget -qO - \
               http://images.validation.linaro.org/${REPO}-repo/dists/${DISTRIBUTION}-backports/main/binary-${ARCHITECTURE}/Packages | \
                 sed -n '/Package: lava-dispatcher/{n;p}' | \
                 sed 's/Version: //' | sed 's/[~|+].*//')

image=linaro/lava-dispatcher-debian-${DISTRIBUTION}-${ARCHITECTURE}:${VERSION}
docker build --no-cache --pull --tag=$image .
echo $image > .docker-tag
