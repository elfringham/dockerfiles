#!/bin/bash

set -e

use_clang_p ()
{
    # The LLD buildbot needs clang for -fuse-ld=lld in stage 2
    # The libcxx bot needs a recent clang to compile tests that
    # require new C++ standard support.
    # Typically we've used clang when the default gcc has problems
    # otherwise gcc is used.
    case "$1" in
        *-libcxx*|linaro-tk1-02) return 0 ;;
        *-lld) return 0 ;;
        *-arm-quick) return 0 ;;
        *-linaro-tk1-01|linaro-tk1-03|linaro-tk1-04|linaro-tk1-05) return 0 ;;
        *-arm-global-isel) return 0 ;;
        *) return 1 ;;
    esac
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
    # Use the oldest maintained clang release (latest - 1).
    # There is a 6.0.1 release but there aren't any AArch64 binaries available
    # so we use 6.0.0 for now.
    release_num=6.0.0
    case "$(uname -m)" in
	aarch64) release_arch=aarch64-linux-gnu ;;
	*) release_arch=armv7a-linux-gnueabihf ;;
    esac
    release_path=/usr/local/clang+llvm-${release_num}-${release_arch}/bin
    cc=$release_path/clang
    cxx=$release_path/clang++
else
    cc=gcc-7
    cxx=g++-7
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
    *-lld)
	# LLD buildbot needs to find ld.lld for stage1 build. GCC does not
        # support -fuse-ld=lld.
	ln -f -s /usr/bin/ld.bfd /usr/local/bin/ld.lld
	;;
    *)
	rm -f /usr/local/bin/ld.lld
	;;
esac

cat <<EOF | sudo -i -u buildslave tee ~buildslave/buildslave/info/admin
Linaro Toolchain Working Group <linaro-toolchain@lists.linaro.org>
EOF

n_cores=$(nproc --all)
case "$2" in
    linaro-armv8-*) hw="${n_cores}-core ARMv8 provided by Packet.net (Type 2A2)" ;;
    linaro-thx1-*) hw="${n_cores}-core ThunderX1 provided by Packet.net (Type 2A)" ;;
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

case "$2" in
    linaro-tk1-*)
	# TK1s have CPU hot-plug, so ninja might detect smaller number of cores
	# available for parallelism.  Explicitly set "default" parallelism.
	cat > /usr/local/bin/ninja <<EOF
#!/bin/sh
exec /usr/bin/ninja -j$n_cores "\$@"
EOF
	;;
    *)
	# Throttle ninja on system load, system memory and container memory
	# limits.
	case "$1" in
	    lab.llvm.org:9994)
		# Run silent bots with single-threaded ninja when average load
		# is beyond twice the number of cores.
		avg_load_opt="-l $((2*$n_cores))"
		;;
	    *)
		avg_load_opt=""
		;;
	esac
	# Make ninja run single-threaded if system or container memory
	# utilization is beyond 50% (-m 50 -M 50).
	# Make ninja stall for up to 5 seconds (-D 5000) before starting
	# a new job when usage decreases under threshold (to avoid rapid
	# increase of resource usage from N_CORES-1 new processes).
	cat > /usr/local/bin/ninja <<EOF
#!/bin/sh
exec /usr/local/bin/ninja.bin -j$n_cores $avg_load_opt -m 50 -M 50 -D 5000 "\$@"
EOF
	;;
esac
chmod +x /usr/local/bin/ninja

# Handle LNT performance bot.
case "$2" in
    linaro-tk1-02)
	# Borrowed from bmk-scripts.git/perfdatadir2csv.sh
	perf_bin="/usr/lib/linux-tools/$(uname -r)/perf"
	if ! [ -e "$perf_bin" ]; then
	    perf_bin="$(find /usr/lib/linux-tools/ -name perf | tail -n 1)"
	    if ! [ -e "$perf_bin" ]; then
		echo "ERROR: Cannot find perf binary"
		exit 1
	    fi
	fi
	cat > /usr/local/bin/perf <<EOF
#!/bin/sh
exec $perf_bin "\$@"
EOF
	chmod +x /usr/local/bin/perf
	;;
esac

sudo -i -u buildslave buildslave restart ~buildslave/buildslave

exec /usr/sbin/sshd -D
