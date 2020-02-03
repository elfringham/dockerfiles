#!/bin/bash

set -e

usage ()
{
    cat <<EOF
$0 [OPTIONS] -- IMAGE GROUP

Options:
  --node jenkins-id/host
	Jenkins node ID to connect as; or "host"

  --verbose true/false
	Whether to run in verbose mode
EOF
    exit 1
}

task="host"
verbose=false

while [ $# -gt 0 ]; do
    case $1 in
	--node|--task) node="$2"; shift ;;
	--verbose) verbose="$2"; shift ;;
	--) shift; break ;;
	*) echo "ERROR: Wrong option: $1"; usage ;;
    esac
    shift
done

image="$1"
shift

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

group="$1"
case "$node:$group" in
    host:*) ;;
    *:tcwg-infra) ;;
    *)
	echo "ERROR: group for node $node should be tcwg-infra"
	exit 1
	;;
esac

mounts=""
mounts="$mounts -v host-home:/home"
mounts="$mounts -v /var/run/docker.sock:/var/run/docker.sock"
mounts="$mounts -v /usr/bin/docker:/usr/bin/docker"
# Bind-mount ssh host keys.
for key in /etc/ssh/ssh_host_*_key{,.pub}; do
    mounts="$mounts -v $key:$key:ro"
done

case "$node" in
    host) ;;
    tcwg-bmk-*)
	mounts="$mounts -v /root/jenkins/$node.secret:/home/tcwg-benchmark/secret-file"
	;;
    tcwg-*)
	mounts="$mounts -v /root/jenkins/$node.secret:/home/tcwg-buildslave/secret-file"
	;;
    *)
	echo "ERROR: Wrong node $node"
	exit 1
	;;
esac

# Use at most half of all available RAM.
memlimit=$(free -m | awk '/^Mem/ { print $2 }')
memlimit=$(($memlimit / 2))m

$DOCKER run -dt --name=$node --network host --restart=unless-stopped $mounts --memory=$memlimit --pids-limit=5000 $image "$group" "$node"
