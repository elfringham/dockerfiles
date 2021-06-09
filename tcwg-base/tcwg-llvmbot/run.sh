#!/bin/bash

set -e

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

if [[ $2 == *"latest-gcc"* ]] ; then
    cc=gcc-11
    cxx=g++-11
else
    release_num=12.0.0
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

# This is a workaround to enable system compiler (LLVM 12) grok SVE options
# without crashing.  This allows us to pass SVE options to stage1 compiler
# while building stage2 compiler, thus testing SVE support with a bootstrap.
# Hopefully, the crashes from "-mllvm -aarch64-sve-vector-bits-min=512" will
# be fixed in LLVM 13 and we will remove this workaround then.
if [[ "$2" == "linaro-aarch64-sve-"*"-2stage" ]] ; then
    cat > /usr/local/bin/cc <<EOF
#!/bin/bash

params=()

while [ \$# -gt 0 ]; do
  if [ x"\$1 \$2" = x"-mllvm -aarch64-sve-vector-bits-min=512" ]; then
    shift 2
    continue
  fi
  params+=("\$1")
  shift
done

exec ccache $cc "\${params[@]}"
EOF

    cat > /usr/local/bin/c++ <<EOF
#!/bin/bash

params=()

while [ \$# -gt 0 ]; do
  if [ x"\$1 \$2" = x"-mllvm -aarch64-sve-vector-bits-min=512" ]; then
    shift 2
    continue
  fi
  params+=("\$1")
  shift
done

exec ccache $cxx "\${params[@]}"
EOF
fi

if [ x"$1" != x"buildkite" ]; then
  cat <<EOF | sudo -i -u tcwg-buildslave tee $worker_dir/info/admin
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
	sed -i -e "s# -l# -j$n_cores -l#" /usr/local/bin/ninja
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
