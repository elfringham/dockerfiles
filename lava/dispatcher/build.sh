#!/bin/sh

# An example invocation of this script would be:
#
# ./build.sh -r production -d stretch -a amd64

set -e

export LANG=C

while getopts "r:d:a:" opt; do
    case $opt in
        r)
            REPO="$OPTARG"
            ;;
        d)
            DISTRIBUTION="$OPTARG"
            ;;
        a)
            ARCH="$OPTARG"
            ;;
        ?)
            echo "Usage:"
            echo "-r - repository such as production or staging"
            echo "-d - distribution such as stretch"
            echo "-a - architecture such as amd64"
            exit 1
            ;;
    esac
done

if [ "$REPO" = staging ]; then
    VERSION="latest"
else
    # Get version by parsing Packages file from respective repo.
    VERSION=$(wget -qO - http://images.validation.linaro.org/${REPO}-repo/dists/${DISTRIBUTION}-backports/main/binary-${ARCH}/Packages \
                     | grep -A5 '^Package: lava-dispatcher' | grep '^Version: ' \
                     | awk '{ print $2 }' \
                     | sed 's/[~|+].*//')
fi

image=linaro/lava-dispatcher-${REPO}-${DISTRIBUTION}-${ARCH}:${VERSION}
docker build --no-cache --pull --tag=$image -f ${REPO}/${DISTRIBUTION}-${ARCH}/Dockerfile .
echo $image > .docker-tag
