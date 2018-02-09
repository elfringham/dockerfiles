#!/bin/bash

set -e

if [ x"$1" = x"start.sh" ]; then
    cat /start.sh
    exit 0
fi

if ! [ -f ~buildslave/buildslave/buildbot.tac ]; then
    # Connect to silent master.
    # Reconnecting to main master should be done by hand.
    sudo -i -u buildslave buildslave create-slave --umask=022 ~buildslave/buildslave "$@"
fi

case "$2" in
    linaro-apm-*|linaro-tk1-*)
	# Download and install clang+llvm into /usr/local for bare-metal
	# bots.
	case "$2" in
	    linaro-apm-*)
		clang_ver=clang+llvm-5.0.1-aarch64-linux-gnu
		;;
	    linaro-tk1-*)
		clang_ver=clang+llvm-5.0.1-armv7a-linux-gnueabihf
		;;
	esac

	(
	    cd /usr/local
	    rm -f $clang_ver.tar.xz
	    wget http://releases.llvm.org/5.0.1/$clang_ver.tar.xz
	    tar -x --strip-components=1 -f $clang_ver.tar.xz
	)
	;;
esac

case "$2" in
    *-libcxx|linaro-tk1-01|linaro-apm-03)
	# Libcxx bots need to be compiled with clang.
	cc=clang
	cxx=clang++
	;;
    *-lld|linaro-apm-04)
	# LLD bots need to be compiled with clang.
	# ??? Adding testStage1=False to LLD bot might enable it to not depend on clang.
	cc=clang
	cxx=clang++
	;;
    *-arm-quick|linaro-tk1-06)
	cc=clang
	cxx=clang++
	;;
    *-arm-full-selfhost|linaro-tk1-05)
	# ??? *-arm-full-selfhost bot doesn't look like it depends on clang.
	cc=clang
	cxx=clang++
	;;
    *-arm-full|linaro-tk1-08)
	# ??? For now we preserve host compiler configuration from non-docker bots.
	cc=clang
	cxx=clang++
	;;
    *)
	cc=gcc
	cxx=g++
	;;
esac

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
$hw ${mem_limit}GB

OS: $(lsb_release -ds)
Kernel: $(uname -rv)
Compiler: $(cc --version | head -n 1)
Linker: $(ld --version | head -n 1)
C Library: $(ldd --version | head -n 1)
EOF

if [ "$n_cores" -ge "40" ]; then
    # We are on a big system, and, presumably, share it with other bots.
    # Use memory-throttling ninja.
    # When running with "-m 50 -M 50" ninja will not start new jobs if
    # system or container memory utilization is beyond 50%.
    cat > /usr/local/bin/ninja <<EOF
#!/bin/sh
exec /usr/local/bin/ninja.bin -m 50 -M 50 -D 5000 "\$@"
EOF
else
    cat > /usr/local/bin/ninja <<EOF
#!/bin/sh
exec /usr/bin/ninja "\$@"
EOF
fi
chmod +x /usr/local/bin/ninja

sudo -i -u buildslave buildslave restart ~buildslave/buildslave

case "$2" in
    linaro-apm-*|linaro-tk1-*)
	exit 0
	;;
    *)
	exec /usr/sbin/sshd -D
	;;
esac
