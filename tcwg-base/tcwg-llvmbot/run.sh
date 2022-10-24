#!/bin/bash

set -e

if [ x"$1" = x"start.sh" ]; then
    cat /start.sh
    exit 0
fi

worker_dir=/home/tcwg-buildbot/worker
if [ x"$1" != x"buildkite" ]; then
  if [ -f $worker_dir/buildbot.tac ]; then
      :
  else
      sudo -i -u tcwg-buildbot buildbot-worker create-worker $worker_dir "$@"
  fi
fi

ccache_basedir=""
case "$2" in
    linaro-tk1-*) ;;
    linaro-*)
	builddir=$(echo "$2" | sed -e "s/linaro-//")
	ccache_basedir="CCACHE_BASEDIR=$worker_dir/$builddir"
	;;
esac
ccache="$ccache_basedir exec ccache"

if [[ $2 == *"latest-gcc"* ]] ; then
    cc=gcc-11
    cxx=g++-11
else
    release_num=15.0.0
    case "$(uname -m)" in
	  aarch64)
      release_arch=aarch64-linux-gnu
      lib_arch=aarch64-unknown-linux-gnu
    ;;
	  *)
      release_arch=armv7a-linux-gnueabihf
      # It is intentional that this is v7l not v7a.
      lib_arch=armv7l-unknown-linux-gnueabihf
    ;;
    esac
    release_path=/usr/local/clang+llvm-${release_num}-${release_arch}
    cc=$release_path/bin/clang
    cxx=$release_path/bin/clang++

    # Starting with clang-11 we need clang's libs in ld.so's search path;
    # otherwise we get failure to find libc++.so.
    echo "$release_path/lib/$lib_arch" > /etc/ld.so.conf.d/clang.conf
    ldconfig
fi

# With default PATH /usr/local/bin/cc and /usr/local/bin/c++ are detected as
# system compilers.  No danger in ccaching results of system compiler since
# we always start with a clean cache in a new container.
cat > /usr/local/bin/cc <<EOF
#!/bin/sh
$ccache $cc "\$@"
EOF
chmod +x /usr/local/bin/cc
cat > /usr/local/bin/c++ <<EOF
#!/bin/sh
$ccache $cxx "\$@"
EOF
chmod +x /usr/local/bin/c++

if [ x"$1" != x"buildkite" ]; then
  cat <<EOF | sudo -i -u tcwg-buildbot tee $worker_dir/info/admin
Linaro Toolchain Working Group <linaro-toolchain@lists.linaro.org>
EOF
fi

n_cores=$(nproc --all)
case "$n_cores" in
    4)
	hw="NVIDIA TK1 ${n_cores}x Cortex-A15"
	;;
    48)
	hw="Fujitsu FX700 ${n_cores}x A64FX"
	;;
    160)
	hw="Ampere Mt. Jade ${n_cores}x Neoverse-N1 provided by Equinix"
	;;
    *)
	hw="${n_cores}x ARMv8"
	;;
esac

# See https://github.com/maxim-kuvyrkov/ninja/commit/8fa112c0104d4cfd0bad0eb62e4cec03f7b51e14
# and https://github.com/maxim-kuvyrkov/ninja/commit/c3eb25f42c3ba5a0c57c482ecdd8051167fcbb61
# about this ugliness.
if [ -f /proc/config.gz ]; then
    # CONFIG_HZ is set to 1000 on TK1s, which, luckily, provide /proc/config.gz.
    zcat /proc/config.gz | grep "^CONFIG_HZ=" | sed -e "s/^CONFIG_HZ=//"
else
    # CONFIG_HZ is set to 250 on all other current systems that we use for
    # LLVM buildbots (this seems to be the current Ubuntu default).
    echo "250"
fi > /etc/ninja_schedstat_hz

if [ -f /sys/fs/cgroup/memory/memory.limit_in_bytes ]; then
    mem_limit=$((($(cat /sys/fs/cgroup/memory/memory.limit_in_bytes) + 512*1024*1024) / (1024*1024*1024)))
else
    mem_limit=$((($(cat /proc/meminfo | grep MemTotal | sed -e "s/[^0-9]\+\([0-9]\+\)[^0-9]\+/\1/") + 512*1024) / (1024*1024)))
fi
if [ x"$1" != x"buildkite" ]; then
  cat <<EOF | sudo -i -u tcwg-buildbot tee $worker_dir/info/host
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
	sed -i -e "s# -l# -j$n_cores -l#" /usr/local/bin/ninja
	;;
    *)
	# Limit parallelism so that each process has at least 1GB of RAM available.
	# Otherwise systems tends to go into deep swap.  This is, mostly, for FX700
	# systems, which have 48 cores, but only 32GB of RAM.
	if [ "$mem_limit" -lt "$n_cores" ]; then
	    sed -i -e "s# -l# -j$mem_limit -l#" /usr/local/bin/ninja
	fi
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
  # Production buildkite bots.
  else
    queue="libcxx-builders-linaro-arm"
  fi

  exec sudo -i -u tcwg-buildbot buildkite-agent start \
    --name $2 \
    --token $3 \
    --tags "queue=$queue,arch=$(arch)" \
    --build-path $worker_dir
else
    exec sudo -i -u tcwg-buildbot buildbot-worker restart --nodaemon $worker_dir
fi
