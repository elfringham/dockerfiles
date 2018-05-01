#!/bin/sh

set -e

trap cleanup_exit INT TERM EXIT

cleanup_exit()
{
    rm -rf start.sh run.sh buildslave/
}

export LANG=C
distro=$(basename ${PWD} | cut -f1 -d '-')
arch=$(basename ${PWD} | cut -f2 -d '-')
name=$(basename ${PWD} | cut -f3- -d '-')
image=linaro/ci-${arch}-${name}-ubuntu:${distro}
top=$(git rev-parse --show-toplevel)

cp $top/tcwg-base/$name/start.sh $top/tcwg-base/$name/run.sh ./

# llvm-config repo is hosted on [secure] dev-private-git.l.o, so we
# can't clone it in here or in "RUN" command.  The docker image
# deployment job arranges clone of llvm-config repo at the following
# location.
if [ x"$USER" = x"buildslave" ]; then
    user="tcwg-buildslave"
    # Add host key for dev-private-review.linaro.org
    # Trying to get a login shell from gerrit will fail, so "|| true"
    ssh -o StrictHostKeyChecking=no -p29418 $user@dev-private-review.linaro.org > /dev/null 2>&1 || true
else
    user="$USER"
fi
git archive --remote ssh://$user@dev-private-review.linaro.org:29418/tcwg/llvm-config refs/heads/master buildslave/ | tar xf -

(cd ..; ./build.sh)
"$top"/tcwg-base/validate-dockerfile.sh Dockerfile
docker pull $image 2>/dev/null || true
docker build --tag=$image .
echo $image > .docker-tag
