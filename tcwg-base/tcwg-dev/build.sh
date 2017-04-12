#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
    rm -f start.sh run.sh
}

export LANG=C
distro=$(basename ${PWD} | cut -f1 -d '-')
arch=$(basename ${PWD} | cut -f2 -d '-')
name=$(basename ${PWD} | cut -f3- -d '-')
image=linaro/ci-${arch}-${name}-ubuntu:${distro}
top=$(git rev-parse --show-toplevel)

cat $top/tcwg-base/tcwg-dev/start.sh.tmpl \
    | sed -e "s#@IMAGE@#$image#g" \
	  -e "s#@DISTRO@#$distro#g" > start.sh
chmod +x start.sh
cp $top/tcwg-base/tcwg-dev/run.sh.tmpl run.sh

(cd ..; ./build.sh)
docker pull $image 2>/dev/null || true
docker build --tag=$image .
