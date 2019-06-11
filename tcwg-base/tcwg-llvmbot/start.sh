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

case "$slavename" in
  linaro-armv8-01-aarch64-full) ;;
  linaro-armv8-01-aarch64-global-isel) ;;
  linaro-armv8-01-aarch64-libcxx) ;;
  linaro-armv8-01-aarch64-libcxx-noeh) ;;
  linaro-armv8-01-aarch64-lld) ;;
  linaro-armv8-01-aarch64-quick) ;;
  linaro-armv8-01-arm-full) ;;
  linaro-armv8-01-arm-full-selfhost) ;;
  linaro-armv8-01-arm-global-isel) ;;
  linaro-armv8-01-arm-libcxx) ;;
  linaro-armv8-01-arm-libcxx-noeh) ;;
  linaro-armv8-01-arm-lld) ;;
  linaro-armv8-01-arm-lnt) ;;
  linaro-armv8-01-arm-quick) ;;
  linaro-armv8-01-arm-selfhost-neon) ;;
  linaro-tk1-*) ;;
  *)
    echo "WARNING: Unknown slavename $slavename"
esac

case "$slavename:$image" in
  *-aarch64-*:*-arm64-*) ;;
  *-arm-*:*-armhf-*) ;;
  linaro-tk1-*:*-armhf-*) ;;
  *)
    echo "ERROR: $slavename should not run on $image."
    echo "Make sure you're running an AArch64 bot on an arm64 image or an ARM bot on an armhf image."
    exit 1
esac

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

case "$buildmaster" in
    "normal") hostname="$slavename" ;;
    *) hostname="$mastername-$slavename" ;;
esac

# Set relative CPU weight of containers running silent bots to 1/20th of
# normal containers.  We want to run a full set of silent bots for
# troubleshooting purposes, but don't want to waste a lot of CPU cycles.
case "$mastername" in
    "silent") cpu_shares=50 ;;
    *) cpu_shares=1000 ;;
esac

memlimit=$(free -m | awk '/^Mem/ { print $2 }')
case "$slavename" in
    linaro-tk1-*)
	# Use at most 90% of RAM on TK1s
	memlimit=$(($memlimit * 9 / 10))m
	;;
    *)
	# Use at most half of all available RAM.
	memlimit=$(($memlimit / 2))m
	;;
esac

case "$slavename" in
    *-lld) pids_limit="15000" ;;
    *) pids_limit="5000" ;;
esac

# IPC_LOCK is required for some implementations of ssh-agent (e.g., MATE's).
# SYS_PTRACE is required for debugger work.
# seccomp:unconfined is required to disable ASLR for sanitizer tests.
caps="--cap-add=IPC_LOCK --cap-add=SYS_PTRACE --security-opt seccomp:unconfined"

$DOCKER run --name=$mastername-$slavename --hostname=$hostname --restart=unless-stopped -dt -p 22 --cpu-shares=$cpu_shares --memory=$memlimit --pids-limit=$pids_limit $caps "$image" "$masterurl" "$slavename" "$password"
