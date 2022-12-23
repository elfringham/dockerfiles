#!/bin/bash

set -euf -o pipefail
set -x

if ! which gcc-latest; then
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
    add-apt-repository -y ppa:ubuntu-toolchain-r/test
    ver=$(apt-cache search "^gcc-[0-9]+\$" | cut -d- -f2 | sort -g | tail -n1)
    DEBIAN_FRONTEND=noninteractive apt-get install -y gcc-$ver g++-$ver
    ln -s $(which gcc-$ver) /usr/bin/gcc-latest
    ln -s $(which g++-$ver) /usr/bin/g++-latest
fi
