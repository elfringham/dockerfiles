#!/bin/sh

set -e

top=$(git rev-parse --show-toplevel)

generate_dockerfile ()
{
    (cd $1

     distro=$(basename ${PWD} | cut -f1 -d '-')
     arch=$(basename ${PWD} | cut -f2 -d '-')
     name=$(basename ${PWD} | cut -f3- -d '-')
     dockerfile_in=$(find $top/tcwg-base -name "$name")/Dockerfile.in
     dockerfile_out=Dockerfile

     if [ -f "$dockerfile_in" ]; then
         echo "# Auto generated from ${dockerfile_in#$top/}. Do not edit." > "$dockerfile_out"
	 $top/tcwg-base/cpp-script.sh -v DISTRO=$distro -v ARCH=$arch \
				      -i $dockerfile_in >> "$dockerfile_out"
         MD5=$(md5sum "$dockerfile_out" | awk '{ print $1; }')
         echo "# checksum: $MD5" >> "$dockerfile_out"
     fi
    )
}

for i in $(find $top -type d -name "*-tcwg-*"); do
    generate_dockerfile $i
done
