#!/bin/sh

set -e

# Can't run multiple copies of this script
exec 9<Dockerfile
flock -x 9

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
    rm -rf \
       home-data/ \
       new-user.sh \
       nvidia-power-cycle.sh \
       nvidia-serial.sh \
       postfix*.in
}

export LANG=C
top=$(git rev-parse --show-toplevel)
distro=$(basename ${PWD} | cut -f1 -d '-')
arch=$(basename ${PWD} | cut -f2 -d '-')
name=$(basename ${PWD} | cut -f3- -d '-')
image=linaro/ci-${arch}-${name}-ubuntu:${distro}
baseimage=$(grep "^FROM" Dockerfile | head -n 1 | cut -d" " -f 2)

rsync -aL $top/tcwg-base/home-data/ ./home-data/
cp -t ./ \
   $top/tcwg-base/new-user.sh \
   $top/tcwg-base/nvidia-power-cycle.sh \
   $top/tcwg-base/nvidia-serial.sh \
   $top/tcwg-base/postfix*.in

# Check if passwd has end-of-line. If no eol at the end of passwd, all "while read line"
# will silently skip last line
if [ "$(tail -c1 ./home-data/passwd | wc -l)" -eq 0 ] ; then
   echo "ERROR: no eol to /home-data/passwd"
   exit 1
fi

"$top"/tcwg-base/validate-checksum.sh Dockerfile
docker pull $baseimage 2>/dev/null || true
docker build --tag=$image .
echo $image > .docker-tag
