#!/bin/bash

set -ex

image="$1"
buildmaster="$2"
slavename="$3"
password="$4"

usage ()
{
    echo "$@"
    cat <<EOF
Usage: $0 <buildmaster> <buildslave> <password>
	E.g., $0 lab.llvm.org:9994 linaro-apm-05 PASSWORD
EOF
    exit 1
}

if groups 2>/dev/null | grep -q docker; then
    # Run docker straight up if $USER is in "docker" group.
    DOCKER="docker"
else
    # Fallback to sudo otherwise.
    DOCKER="sudo docker"
fi

case "$buildmaster" in
    "normal")
	mastername="normal"
	masterurl="lab.llvm.org:9990"
	;;
    "silent")
	mastername="silent"
	masterurl="lab.llvm.org:9994"
	;;
    *)
	mastername="custom"
	masterurl="$buildmaster"
esac

# Set relative CPU weight of containers running silent bots to 1/20th of
# normal containers.  We want to run a full set of silent bots for
# troubleshooting purposes, but don't want to waste a lot of CPU cycles.
case "$mastername" in
    "silent") cpu_shares=50 ;;
    *) cpu_shares=1000 ;;
esac

# Use 64G out of 128G.
memlimit="64"

case "$slavename" in
    *-lld) pids_limit="15000" ;;
    *) pids_limit="5000" ;;
esac

# IPC_LOCK is required for some implementations of ssh-agent (e.g., MATE's).
# SYS_PTRACE is required for debugger work.
# seccomp:unconfined is required to disable ASLR for sanitizer tests.
caps="--cap-add=IPC_LOCK --cap-add=SYS_PTRACE --security-opt seccomp:unconfined"

$DOCKER run --name=$mastername-$slavename --hostname=$mastername-$slavename --restart=unless-stopped -dt -p 22 --cpu-shares=$cpu_shares --memory=${memlimit}G --pids-limit=$pids_limit $caps "$image" "$masterurl" "$slavename" "$password"
