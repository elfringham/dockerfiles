#!/bin/bash

set -e

usage ()
{
    cat <<EOF
$0 [OPTIONS] -- IMAGE [GROUP [NODE]]

Options:
  --verbose true/false
	Whether to run in verbose mode

  IMAGE
	Docker tcwg-host image

  GROUP
	User group to configure access to; or "all"

  NODE
	Jenkins node ID to connect as; or "host"
EOF
    exit 1
}

group="all"
node="host"
verbose=false
additional_options=""

while [ $# -gt 0 ]; do
    case $1 in
	--verbose) verbose="$2"; shift ;;
	--additional_options) additional_options="$2"; shift ;;
	--) shift; break ;;
	*) echo "ERROR: Wrong option: $1"; usage ;;
    esac
    shift
done

image="$1"
group="${2-$group}"
node="${3-$node}"

if $verbose; then
    set -x
fi

if [ x"$image" = x"" ]; then
  echo "ERROR: image name not provided"
  usage
fi

if [ x"$(id -u)" = x"0" ] || groups 2>/dev/null | grep -q docker; then
    # Run docker straight up if $USER is root or in "docker" group.
    DOCKER="docker"
elif groups tcwg-buildslave 2>/dev/null | grep -q docker; then
    # If tcwg-buildslave user is present, use it to start the container
    # to have [sudo] log record of container startups.
    DOCKER="sudo -u tcwg-buildslave docker"
else
    # Fallback to sudo otherwise.
    DOCKER="sudo docker"
fi

mounts=""
mounts="$mounts -v /home:/home"
mounts="$mounts -v /var/run/docker.sock:/var/run/docker.sock"
mounts="$mounts -v /usr/bin/docker:/usr/bin/docker"
# Bind-mount ssh host keys.
for key in /etc/ssh/ssh_host_*_key{,.pub}; do
    mounts="$mounts -v $key:$key:ro"
done

# Use at most half of all available RAM.
memlimit=$(free -m | awk '/^Mem/ { print $2 }')
memlimit=$(($memlimit / 2))m

case "$(uname -m):$($DOCKER --version | cut -d" " -f3)" in
    armv7l:18*)
	# Somewhere between docker-ce 19.03.5 and 19.03.6 docker bridge network
	# got broken on, at least, armhf with 3.10 kernel (aka TK1s).
	# At the same time to run ubuntu:focal we need docker-ce 19.03.9-ish
	# due to seccomp not supporting some of the syscalls.
	# We have two options:
	# 1. Use old docker and workaround ubuntu:focal's seccomp problem by
	# disabling it via --privileged option.
	# 2. Use new docker and workaround broken bridge network by using
	# --network host.
	# In the case of tcwg-tk1-* boards, which are used for jenkins CI, we
	# need the bridge network, so we choose (1).
	workaround="--privileged"
	;;
esac

$DOCKER run -dt --name=$node --network host --restart=unless-stopped $mounts \
	--memory=$memlimit --pids-limit=5000 $workaround $additional_options \
	$image "$group" "$node"
