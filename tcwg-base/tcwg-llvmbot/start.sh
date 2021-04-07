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

	For buildkite, set <buildmaster> to "buildkite" and
	<password> to your buildkite token.
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

# List of supported build slaves.
# Please keep synced with tcwg-update-llvmbot-containers.sh.
case "$slavename" in
  linaro-aarch64-full) ;;
  linaro-aarch64-global-isel) ;;
  linaro-armv7-selfhost) ;;
  linaro-armv7-global-isel) ;;
  linaro-aarch64-libcxx) ;;
  linaro-aarch64-lld) ;;
  linaro-aarch64-lldb) ;;
  linaro-aarch64-quick) ;;
  linaro-aarch64-flang-oot) ;;
  linaro-aarch64-flang-dylib) ;;
  linaro-aarch64-flang-sharedlibs) ;;
  linaro-aarch64-flang-oot-new-driver) ;;
  linaro-aarch64-flang-debug) ;;
  linaro-aarch64-flang-latest-clang) ;;
  linaro-aarch64-flang-release) ;;
  linaro-aarch64-flang-rel-assert) ;;
  linaro-aarch64-flang-latest-gcc) ;;
  linaro-armv8-libcxx) ;;
  linaro-armv8-lld) ;;
  linaro-arm-lldb) ;;
  linaro-armv7-lnt) ;;
  linaro-armv7-quick) ;;
  linaro-tk1-*) ;;
  *)
    echo "WARNING: Unknown slavename $slavename"
    ;;
esac

case "$slavename:$image" in
  *-aarch64-*:*-arm64-*) ;;
  *-arm*-*:*-armhf-*) ;;
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
    "buildkite")
	mastername="buildkite"
	masterurl="buildkite"
	;;
    *)
	mastername="custom"
	masterurl="$buildmaster"
esac

case "$buildmaster" in
    "normal") hostname="$slavename" ;;
    *) hostname="$mastername-$slavename" ;;
esac

# Set relative CPU weight of containers running
#  - quick bots to 10x usual priority
#  - full bots to 5x usual priority
case "$slavename" in
    *-quick) cpu_shares=10000 ;;
    *-aarch64-full|*-armv7-selfhost) cpu_shares=5000 ;;
    *) cpu_shares=1000 ;;
esac

mounts=""
# Bind-mount ssh host keys.
for key in /etc/ssh/ssh_host_*_key{,.pub}; do
    mounts="$mounts -v $key:$key:ro"
done

memlimit=$(free -m | awk '/^Mem/ { print $2 }')
case "$slavename" in
    linaro-tk1-*)
	# Use at most 90% of RAM on TK1s
	memlimit=$(($memlimit * 9 / 10))m
	# The tk1 default 3.10 kernel places the [sigpage] segment between the
	# [heap] and [stack] segment which causes failures on to some programs
	# (more information on https://projects.linaro.org/browse/UM-70).  The
	# unlimited statck mitigates a failure in stage2 clang due high stack
	# usage.
	caps_system="--ulimit stack=-1"
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
caps="--cap-add=IPC_LOCK --cap-add=SYS_PTRACE --security-opt seccomp:unconfined $caps_system"

$DOCKER run --name=$mastername-$slavename --hostname=$hostname --restart=unless-stopped -dt -p 22 --cpu-shares=$cpu_shares $mounts --memory=$memlimit --pids-limit=$pids_limit $caps "$image" "$masterurl" "$slavename" "$password"
