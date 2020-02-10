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

while [ $# -gt 0 ]; do
    case $1 in
	--verbose) verbose="$2"; shift ;;
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
mounts="$mounts -v host-home:/home"
mounts="$mounts -v /var/run/docker.sock:/var/run/docker.sock"
mounts="$mounts -v /usr/bin/docker:/usr/bin/docker"
# Bind-mount ssh host keys.
for key in /etc/ssh/ssh_host_*_key{,.pub}; do
    mounts="$mounts -v $key:$key:ro"
done

# Use at most half of all available RAM.
memlimit=$(free -m | awk '/^Mem/ { print $2 }')
memlimit=$(($memlimit / 2))m

$DOCKER run -dt --name=$node --network host --restart=unless-stopped $mounts --memory=$memlimit --pids-limit=5000 $image "$group" "$node"
