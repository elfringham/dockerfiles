#!/bin/sh

set -e

depends="$(cat build-depends.list)"

for i in $depends; do
    (
	cd ../$i;
	echo "Building $i"
	./build.sh
	if [ -e ./build-depends.sh ]; then
	    ./build-depends.sh
	fi
    )
done
