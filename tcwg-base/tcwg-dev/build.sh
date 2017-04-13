#!/bin/sh

set -e

top=$(git rev-parse --show-toplevel)

for i in $top/*-tcwg-base/*-tcwg-dev/; do
    (cd $i; ./build.sh)
done
