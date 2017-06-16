#!/bin/sh

set -e

#
top=$(git rev-parse --show-toplevel)

for i in $top/*-tcwg-base/; do
    (cd $i; ./build.sh)
done
