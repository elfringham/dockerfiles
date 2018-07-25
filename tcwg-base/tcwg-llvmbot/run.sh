#!/bin/bash

set -e

bare_metal_bot_p ()
{
    case "$1" in
	"linaro-tk1-"*) return 0 ;;
	"linaro-apm-02"|"linaro-apm-05") return 1 ;;
	"linaro-apm-"*) return 0 ;;
	*) return 1 ;;
    esac
}

use_clang_p ()
{
    # The LLD buildbot needs clang for -fuse-ld=lld in stage 2
    # The libcxx bot needs a recent clang to compile tests that
    # require new C++ standard support.
    # Typically we've used clang when the default gcc has problems
    # otherwise gcc is used.
    case "$1" in
        *-libcxx*|linaro-tk1-01|linaro-apm-03) return 0 ;;
        *-lld|linaro-apm-04) return 0 ;;
        *-arm-quick|linaro-tk1-06) return 0 ;;
        *-arm-full-selfhost|linaro-tk1-05) return 0 ;;
        *-arm-full|linaro-tk1-08) return 0 ;;
        *-arm-global-isel|linaro-tk1-09) return 0 ;;
        *) return 1 ;;
    esac
}

# Use the oldest maintained clang release (latest - 1).
setup_clang_release()
{
    # There is a 6.0.1 release but there aren't any AArch64 binaries available
    # so we use 6.0.0 for now.
    local release_num=6.0.0
    case "$(uname -m)" in
    aarch64)
	local clang_ver=clang+llvm-${release_num}-aarch64-linux-gnu
	;;
    *)
	local clang_ver=clang+llvm-${release_num}-armv7a-linux-gnueabihf
	;;
    esac

    # Download and install clang+llvm into /usr/local
    (
	cd /usr/local
	wget -c --progress=dot:giga http://releases.llvm.org/${release_num}/$clang_ver.tar.xz
	tar xf $clang_ver.tar.xz
    )
    cc=/usr/local/$clang_ver/bin/clang
    cxx=/usr/local/$clang_ver/bin/clang++
}

if [ x"$1" = x"start.sh" ]; then
    cat /start.sh
    exit 0
fi

if ! [ -f ~buildslave/buildslave/buildbot.tac ]; then
    # Connect to silent master.
    # Reconnecting to main master should be done by hand.
    sudo -i -u buildslave buildslave create-slave --umask=022 ~buildslave/buildslave "$@"
fi

if use_clang_p $2 ; then
    setup_clang_release
else
    cc=gcc
    cxx=g++
fi

# With default PATH /usr/local/bin/cc and /usr/local/bin/c++ are detected as
# system compilers.  No danger in ccaching results of system compiler since
# we always start with a clean cache in a new container.
cat > /usr/local/bin/cc <<EOF
#!/bin/sh
exec ccache $cc "\$@"
EOF
chmod +x /usr/local/bin/cc
cat > /usr/local/bin/c++ <<EOF
#!/bin/sh
exec ccache $cxx "\$@"
EOF
chmod +x /usr/local/bin/c++

case "$2" in
    *-lld|linaro-apm-04)
	# LLD buildbot needs to find ld.lld for stage1 build. GCC does not
        # support -fuse-ld=lld.
	ln -f -s /usr/bin/ld.bfd /usr/local/bin/ld.lld
	;;
    *)
	rm -f /usr/local/bin/ld.lld
	;;
esac

cat <<EOF | sudo -i -u buildslave tee ~buildslave/buildslave/info/admin
Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>
EOF

n_cores=$(nproc --all)
case "$2" in
    linaro-apm-*) hw="APM Mustang ${n_cores}-core X-Gene" ;;
    linaro-armv8-*) hw="${n_cores}-core ARMv8 provided by Packet.net (Type 2A2)" ;;
    linaro-tk1-*) hw="NVIDIA TK1 ${n_cores}-core Cortex-A15" ;;
esac

if [ -f /sys/fs/cgroup/memory/memory.limit_in_bytes ]; then
    mem_limit=$((($(cat /sys/fs/cgroup/memory/memory.limit_in_bytes) + 512*1024*1024) / (1024*1024*1024)))
else
    mem_limit=$((($(cat /proc/meminfo | grep MemTotal | sed -e "s/[^0-9]\+\([0-9]\+\)[^0-9]\+/\1/") + 512*1024) / (1024*1024)))
fi
cat <<EOF | sudo -i -u buildslave tee ~buildslave/buildslave/info/host
$hw; RAM ${mem_limit}GB

OS: $(lsb_release -ds)
Kernel: $(uname -rv)
Compiler: $(cc --version | head -n 1)
Linker: $(ld --version | head -n 1)
C Library: $(ldd --version | head -n 1)
EOF

if bare_metal_bot_p "$2"; then
    # TK1s have CPU hot-plug, so ninja might detect smaller number of cores
    # available for parallelism.  Explicitly set "default" parallelism.
    cat > /usr/local/bin/ninja <<EOF
#!/bin/sh
exec /usr/bin/ninja -j$n_cores "\$@"
EOF
else
    # Throttle ninja on system load, system memory and container memory limit.
    # When running with "-l 2*N_CORES -m 50 -M 50" ninja will not start new jobs
    # if system or container memory utilization is beyond 50% or when load is
    # above double the core count.  Ninja will also stall up to 5 seconds (-D 5000)
    # before starting a new job to avoid rapid increase of resource usage.
    cat > /usr/local/bin/ninja <<EOF
#!/bin/sh
exec /usr/local/bin/ninja.bin -j$n_cores -l $((2*$n_cores)) -m 50 -M 50 -D 5000 "\$@"
EOF
fi
chmod +x /usr/local/bin/ninja

sudo -i -u buildslave buildslave restart ~buildslave/buildslave

if bare_metal_bot_p "$2"; then
    exit 0
fi

exec /usr/sbin/sshd -D
