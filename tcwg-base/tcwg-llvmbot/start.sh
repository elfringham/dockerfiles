#!/bin/bash

set -ex

usage ()
{
    cat <<EOF
Usage: $0 -- <image> <buildmaster> <buildbot> <password>
	E.g., $0 -- linaro/ci-arm64-tcwg-llvmbot-ubuntu:focal lab.llvm.org:9994 linaro-apm-05 PASSWORD

	For buildkite, set <buildmaster> to "buildkite" and
	<password> to your buildkite token.
EOF
    exit 0
}

while [ $# -gt 0 ]; do
    case $1 in
  --help) usage ;;
  # This script does not support any -- options but the other tcwg-build/dev/host
  # do and they end up passed to us as well. We assume they come before a " -- "
  # after which we get the options we care about.
	--) shift; break ;;
  *) shift ;;
    esac
    shift
done

# Now we've dropped everything up to and including the " -- ".
image="$1"
buildmaster="$2"
botname="$3"
password="$4"

if groups 2>/dev/null | grep -q docker; then
    # Run docker straight up if $USER is in "docker" group.
    DOCKER="docker"
else
    # Fallback to sudo otherwise.
    DOCKER="sudo docker"
fi

# List of supported build bots.
# Please keep synced with tcwg-update-llvmbot-containers.sh.
case "$botname" in
    linaro-lldb-arm-ubuntu) ;;
    linaro-lldb-aarch64-ubuntu) ;;
    linaro-aarch64-libcxx-*) ;;
    linaro-armv8-libcxx-*) ;;
    linaro-clang-aarch64-sve-vls) ;;
    linaro-clang-aarch64-sve-vla) ;;
    linaro-clang-aarch64-sve-vls-2stage) ;;
    linaro-clang-aarch64-sve-vla-2stage) ;;
    linaro-clang-armv7-lnt) ;;
    linaro-clang-armv7-2stage) ;;
    linaro-clang-armv7-global-isel) ;;
    linaro-clang-armv7-vfpv3-2stage) ;;
    linaro-clang-armv8-quick) ;;
    linaro-clang-armv8-lld-2stage) ;;
    linaro-clang-aarch64-quick) ;;
    linaro-clang-aarch64-lld-2stage) ;;
    linaro-clang-aarch64-global-isel) ;;
    linaro-clang-aarch64-full-2stage) ;;
    linaro-flang-aarch64-dylib) ;;
    linaro-flang-aarch64-sharedlibs) ;;
    linaro-flang-aarch64-out-of-tree) ;;
    linaro-flang-aarch64-debug) ;;
    linaro-flang-aarch64-latest-clang) ;;
    linaro-flang-aarch64-release) ;;
    linaro-flang-aarch64-rel-assert) ;;
    linaro-flang-aarch64-latest-gcc) ;;
    linaro-tk1-*) ;;
  *)
    echo "WARNING: Unknown botname $botname"
    ;;
esac

case "$botname:$image" in
  *-aarch64-*:*-arm64-*) ;;
  *-arm*-*:*-armhf-*) ;;
  linaro-tk1-*:*-armhf-*) ;;
  *)
    echo "ERROR: $botname should not run on $image."
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
    "normal") hostname="$botname" ;;
    *) hostname="$mastername-$botname" ;;
esac

# Set relative CPU weight of containers running.
case "$botname" in
    # lldb 100x usual.
    *-lldb-*) cpu_shares=100000 ;;
    # quick bots 10x usual.
    *-quick) cpu_shares=10000 ;;
    # Fixed core bots at 200x usual, so they always get their cores.
    *-libcxx-*|\
    *-sve-vls*|\
    *-sve-vla-2stage|\
    *-armv8-lld-2stage|\
    *-aarch64-full-2stage|\
    *-aarch64-lld-2stage|\
    *-armv7-vfpv3-2stage|\
    *-armv7-2stage)
      cpu_shares=200000 ;;
    *) cpu_shares=1000 ;;
esac

# For many bots we give them a fixed set of CPU numers.
# This means that "nproc" and other automatic parallelism
# is constant. This prevents testing issues due to varying
# resource levels.
# Note: Other containers can use these cores if they are idle
# so this is not reserving them, it's just limiting where
# these container's processes can go.
#
# Here we also limit everything but SVE vla 1 stage to just 1 core.
# This is a temporary measure while we work out what the hardware
# capacity really is.
case "$botname" in
  *aarch64-libcxx-01) cpuset_cpus="--cpuset-cpus=0-7" ;;
  *aarch64-libcxx-02) cpuset_cpus="--cpuset-cpus=8-15" ;;
  # Arm 32 bit needs a few more to match the AArch64 build time.
  *armv8-libcxx-01)   cpuset_cpus="--cpuset-cpus=16-27" ;;
  *armv8-libcxx-02)   cpuset_cpus="--cpuset-cpus=28-39" ;;
  *armv8-libcxx-03)   cpuset_cpus="--cpuset-cpus=40-51" ;;
  *armv8-libcxx-04)   cpuset_cpus="--cpuset-cpus=52-63" ;;
  # 2 stage bots running on jade-01, 15 cores each.
  *-armv8-lld-2stage)    cpuset_cpus="--cpuset-cpus=0-14"  ;;
  *-aarch64-full-2stage) cpuset_cpus="--cpuset-cpus=15-29" ;;
  *-aarch64-lld-2stage)  cpuset_cpus="--cpuset-cpus=30-44" ;;
  *-armv7-vfpv3-2stage)  cpuset_cpus="--cpuset-cpus=45-59" ;;
  *-armv7-2stage)        cpuset_cpus="--cpuset-cpus=60-74" ;;
  # SVE bots running on fx-02
  *sve-vla-2stage) cpuset_cpus="--cpuset-cpus=10" ;;
  *sve-vls) cpuset_cpus="--cpuset-cpus=11" ;;
  *sve-vls-2stage) cpuset_cpus="--cpuset-cpus=12" ;;
  *) cpuset_cpus="" ;;
esac

mounts=""
# Bind-mount ssh host keys.
for key in /etc/ssh/ssh_host_*_key{,.pub}; do
    mounts="$mounts -v $key:$key:ro"
done

# Add ccache mount.  We differentiate ccache mounts on image arch and OS.
# Using same cache for different architectures would needlessly pollute cache
# (i.e., armhf and aarch64 images use different system compilers).
# Using same cache for different OS versions can cause problems due to
# different ccache versions.
ccache_id=$(echo "$image" | sed -e "s#linaro/ci-\(.*\)-tcwg-llvmbot-ubuntu:\(.*\)\$#\1-\2#")
mounts="$mounts -v ccache-$ccache_id:/home/tcwg-buildbot/.ccache"

memlimit=$(free -m | awk '/^Mem/ { print $2 }')
network=""
case "$botname" in
    linaro-tk1-*)
	# Use at most 90% of RAM on TK1s
	memlimit=$(($memlimit * 9 / 10))m
	# The tk1 default 3.10 kernel places the [sigpage] segment between the
	# [heap] and [stack] segment which causes failures on to some programs
	# (more information on https://projects.linaro.org/browse/UM-70).  The
	# unlimited statck mitigates a failure in stage2 clang due high stack
	# usage.
	caps_system="--ulimit stack=-1"
	# Somewhere between docker-ce 19.03.5 and 19.03.6 docker bridge network
	# got broken on, at least, armhf with 3.10 kernel (aka TK1s).
	# At the same time to run ubuntu:focal we need docker-ce 19.03.9-ish
	# due to seccomp not supporting some of the syscalls.
	# We have two options:
	# 1. Use old docker and workaround ubuntu:focal's seccomp problem by
	# disabling it via --privileged option.
	# 2. Use new docker and workaround broken bridge network by using
	# --network host.
	# In the case of LLVM bots we don't need bridge network, so we choose
	# option (2).
	network="--network host"
	# Using host network also requires us to use the actual host name.
	# Otherwise "sudo" in /run.sh complains about unknown host.
	hostname=$(hostname)
	;;
    linaro-clang-aarch64-sve-*)
	# Each SVE bot gets 1/4 of the total RAM.
	memlimit=$(($memlimit / 4))m
	;;
    *)
	# Use at most half of all available RAM.
	memlimit=$(($memlimit / 2))m
	;;
esac
case "$botname" in
    *-lld-2stage|*-aarch64-full-2stage)
	# LLD bots have been requiring high PIDs limit for as long as they
	# have been setup.
	#
	# Buildbot client in AArch64 full bot has started to sporadically
	# crash after migration of bots from D05 to Mt. Jade machine with error
	# "cgroup: fork rejected by pids controller in /docker/FOOBAR"
	# This is, apparently, due to
	# LeakSanitizer-AddressSanitizer-aarch64::many_threads_detach.cpp
	# test, which creates 10000 threads.
	# This affects AArch64 bots that enable compiler-rt:
	# - linaro-aarch64-lld
	# - linaro-aarch64-full
	#
	# I can't readily explain why we haven't seen this problem on D05
	# machine.  One possibility is that kernel scheduled threads
	# differently on 64-core D05 and 160-core Mt. Jade machines.
	# And that D05 was lucky to never see more than, say, 3000-4000
	# concurrent threads, but Mt. Jade manages to see, say, 4000-5000
	# threads.
	pids_limit="15000" ;;
    *) pids_limit="5000" ;;
esac

# IPC_LOCK is required for some implementations of ssh-agent (e.g., MATE's).
# SYS_PTRACE is required for debugger work.
# seccomp:unconfined is required to disable ASLR for sanitizer tests.
caps="--cap-add=IPC_LOCK --cap-add=SYS_PTRACE --security-opt seccomp:unconfined $caps_system"

if [ x"$(uname -m)" = x"x86_64" ]; then
    # Copy QEMU binary to $HOME, which is bind-mounted from host.  This way
    # we'll have QEMU bind-mount equally accessible from the main host and
    # from host/jenkins containers, from which we are starting tcwg-llvmbot
    # containers.
    # The host needs to have binfmt-misc magic configured for this to work.
    # With the magic configured, all we need is to provide qemu-aarch64-static
    # binary in PATH inside the container, and it'll be automatically picked up
    # for execution of aarch64 binaries.
    qemu_bin=$(mktemp -p $HOME)
    cp "$(which qemu-aarch64-static)" "$qemu_bin"
    chmod +x "$qemu_bin"
    mounts="$mounts -v $qemu_bin:/bin/qemu-aarch64-static"
fi

# Use --init so that PID 1 is docker-init which will reap zombie processes for us
$DOCKER run --name=$mastername-$botname --hostname=$hostname $network --restart=unless-stopped -dt --cpu-shares=$cpu_shares $cpuset_cpus $mounts --memory=$memlimit --pids-limit=$pids_limit --init $caps "$image" "$masterurl" "$botname" "$password"

if [ x"$(uname -m)" = x"x86_64" ]; then
    rm -f "$qemu_bin"
fi
