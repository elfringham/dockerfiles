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
        *-latest-clang) return 0 ;;
        *-libcxx*|linaro-tk1-02) return 0 ;;
        *-lld) return 0 ;;
        *-lldb) return 0 ;;
        *-armv*-quick) return 0 ;;
        *-linaro-tk1-01|linaro-tk1-03|linaro-tk1-04|linaro-tk1-05) return 0 ;;
        *-armv*-global-isel) return 0 ;;
        *) return 1 ;;
    esac
}

if [ x"$1" = x"start.sh" ]; then
    cat /start.sh
    exit 0
fi

worker_dir=~tcwg-buildslave/worker
if [ x"$1" != x"buildkite" ]; then
  if [ -f $worker_dir/buildbot.tac ]; then
      :
  elif which buildbot-worker >/dev/null; then
      sudo -i -u tcwg-buildslave buildbot-worker create-worker $worker_dir "$@"
  else
      sudo -i -u tcwg-buildslave buildslave create-slave --umask=022 $worker_dir "$@"
  fi
fi

if use_clang_p $2 ; then
    # Some bots need recent C++ versions or clang-specific features, so we use
    # a recent clang instead of the system GCC. Currently we use the 10.0.1
    # release.
    if [[ $2 == *"latest-clang"* ]] || [[ $2 == *"-libcxx"* ]] ; then
	release_num=11.1.0
    else
	release_num=10.0.1
    fi
    case "$(uname -m)" in
	aarch64) release_arch=aarch64-linux-gnu ;;
	*) release_arch=armv7a-linux-gnueabihf ;;
    esac
    release_path=/usr/local/clang+llvm-${release_num}-${release_arch}
    cc=$release_path/bin/clang
    cxx=$release_path/bin/clang++

    # Starting with clang-11 we need clang's libs in ld.so's search path;
    # otherwise we get failure to find libc++.so.
    echo "$release_path/lib" > /etc/ld.so.conf.d/clang.conf
    ldconfig
elif [[ $2 == *"latest-gcc"* ]] ; then
    cc=gcc-10
    cxx=g++-10
elif [ x"$(lsb_release -cs)" = x"bionic" ]; then
    cc=gcc-9
    cxx=g++-9
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
    *-lld)
	# LLD buildbot needs to find ld.lld for stage1 build. GCC does not
        # support -fuse-ld=lld.
	ln -f -s /usr/bin/ld.bfd /usr/local/bin/ld.lld
	;;
    *-debug)
        release_num=10.0.1
        release_arch=aarch64-linux-gnu
        release_path=/usr/local/clang+llvm-${release_num}-${release_arch}
        ln -f -s $release_path/bin/lld /usr/local/bin/ld.lld
        ;;
    *)
	rm -f /usr/local/bin/ld.lld
	;;
esac

if [ x"$1" != x"buildkite" ]; then
  cat <<EOF | sudo -i -u tcwg-buildslave tee $worker_dir/info/admin
Linaro Toolchain Working Group <linaro-toolchain@lists.linaro.org>
EOF
fi

n_cores=$(nproc --all)
case "$2" in
    linaro-tk1-*) hw="NVIDIA TK1 ${n_cores}-core Cortex-A15" ;;
    linaro-*) hw="${n_cores}-core ARMv8 provided by Packet.net" ;;
esac

if [ -f /sys/fs/cgroup/memory/memory.limit_in_bytes ]; then
    mem_limit=$((($(cat /sys/fs/cgroup/memory/memory.limit_in_bytes) + 512*1024*1024) / (1024*1024*1024)))
else
    mem_limit=$((($(cat /proc/meminfo | grep MemTotal | sed -e "s/[^0-9]\+\([0-9]\+\)[^0-9]\+/\1/") + 512*1024) / (1024*1024)))
fi
if [ x"$1" != x"buildkite" ]; then
  cat <<EOF | sudo -i -u tcwg-buildslave tee $worker_dir/info/host
$hw; RAM ${mem_limit}GB

OS: $(lsb_release -ds)
Kernel: $(uname -rv)
Compiler: $(cc --version | head -n 1)
Linker: $(ld --version | head -n 1)
C Library: $(ldd --version | head -n 1)
EOF
fi

case "$2" in
    linaro-tk1-*)
	# TK1s have CPU hot-plug, so ninja might detect smaller number of cores
	# available for parallelism.  Explicitly set "default" parallelism.
	# Note that this overwrites ninja wrapper created in
	# tcwg-base/Dockerfile.in.  That wrapper limits system load,
	# which we don't particularly need on TK1s (since we are running
	# a single bot containers per board).
	cat > /usr/local/bin/ninja <<EOF
#!/bin/sh
exec /usr/bin/ninja -j$n_cores "\$@"
EOF
	chmod +x /usr/local/bin/ninja
	;;
esac

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

if [ x"$1" = x"buildkite" ]; then
  # Add load testing bots. Trigger these by modifying the Buildkite
  # config in a Phabricator review.
  if [[ $2 == *"-test" ]]; then
    queue="libcxx-builders-linaro-arm-test"
  else
    queue="libcxx-builders-linaro-arm"
  fi

  sudo -i -u tcwg-buildslave buildkite-agent start \
    --name $2 \
    --token $3 \
    --tags "queue=$queue,arch=$(arch)" \
    --build-path $worker_dir
else
  if which buildbot-worker >/dev/null; then
      sudo -i -u tcwg-buildslave buildbot-worker restart $worker_dir
  else
      sudo -i -u tcwg-buildslave buildslave restart $worker_dir
  fi
fi

exec /usr/sbin/sshd -D
