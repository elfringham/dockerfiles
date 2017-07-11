#!/bin/sh

set -e

top=$(git rev-parse --show-toplevel)

generate_dockerfile ()
{
    (cd $1

     distro=$(basename ${PWD} | cut -f1 -d '-')
     arch=$(basename ${PWD} | cut -f2 -d '-')
     name=$(basename ${PWD} | cut -f3- -d '-')
     dockerfile_in=$(find $top -name "$name")/Dockerfile.in

     if [ -f "$dockerfile_in" ]; then
	 $top/tcwg-base/cpp-script.sh -v DISTRO=$distro -v ARCH=$arch \
				      -i $dockerfile_in > Dockerfile
     fi
    )
}

for i in $(find $top -name "*-tcwg-*"); do
    generate_dockerfile $i
done
