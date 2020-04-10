#!/bin/bash

set -euf -o pipefail

top=$(git rev-parse --show-toplevel)

case $(uname -m) in
    x86_64) arch="amd64\|i386" ;;
    aarch64) arch="arm64\|armhf" ;;
esac

dirs=($(find "$top" -type d -name "*-tcwg*" | grep "$arch"))

rm -f $top/tcwg-base/status

for dir in "${dirs[@]}"; do
    (
	cd $dir

	image="$(basename $dir)"
	echo "START: $image" | tee -a $top/tcwg-base/status
	./build.sh > build.log 2>&1 &
	res=0 && wait $! || res=$?
	if [ $res = 0 ]; then
	    echo "PASS: $image" | tee -a $top/tcwg-base/status
	else
	    echo "FAIL: $image" | tee -a $top/tcwg-base/status
	    tail build.log
	fi
    ) &
done

wait
