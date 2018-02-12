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

# CXX, LLD and LNT bots need additional configuration, and
# are not supported yet.
case "$mastername:$slavename:$(hostname):$image" in
    # No restrictions for custom masters:
    custom:*:*:*) ;;
    # Almost no restrictions for the silent master:
    silent:*:linaro-armv8-*:*) ;;
    silent:*:r*-a*:*) ;;
    # Restrictions for the normal master:
    normal:*:linaro-armv8-*:*) ;;
    normal:*:r*-a*:*-arm64-*) ;;
    *)
	usage "ERROR: Wrong mastername:slavename:hostname:image combination: $mastername:$slavename:$(hostname):$image"
	;;
esac

case "$slavename" in
    linaro-armv8-*)
	# Use 64G out of 128G.
	memlimit="64"
	;;
    *)
	# Use at most 30G or 90% of all RAM.
	memlimit=$(($(free -g | awk '/^Mem/ { print $2 }') * 9 / 10))
	if [ "$memlimit" -gt "30" ]; then
	    memlimit="30"
	fi
	;;
esac

# IPC_LOCK is required for some implementations of ssh-agent (e.g., MATE's).
# SYS_PTRACE is required for debugger work.
# seccomp:unconfined is required to disable ASLR for sanitizer tests.
caps="--cap-add=IPC_LOCK --cap-add=SYS_PTRACE --security-opt seccomp:unconfined"

$DOCKER run --name=$mastername-$slavename --hostname=$mastername-$slavename --restart=unless-stopped -dt -p 22 --memory=${memlimit}G --pids-limit=2000 $caps "$image" "$masterurl" "$slavename" "$password"
