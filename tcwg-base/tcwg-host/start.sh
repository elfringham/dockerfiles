#!/bin/bash

set -e

usage ()
{
    cat <<EOF
$0 [OPTIONS] -- IMAGE

Options:
  --verbose true/false
	Whether to run in verbose mode
EOF
    exit 1
}

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

if $verbose; then
    set -x
fi

if [ x"$image" = x"" ]; then
  echo "ERROR: image name not provided"
  usage
fi

if groups tcwg-buildslave 2>/dev/null | grep -q docker; then
    # If tcwg-buildslave user is present, use it to start the container
    # to have [sudo] log record of container startups.
    DOCKER="sudo -u tcwg-buildslave docker"
elif [ x"$(id -u)" = x"0" ] || groups 2>/dev/null | grep -q docker; then
    # Run docker straight up if $USER is root or in "docker" group.
    DOCKER="docker"
else
    # Fallback to sudo otherwise.
    DOCKER="sudo docker"
fi

mounts=""
mounts="$mounts -v host-home:/home"
mounts="$mounts -v /var/run/docker.sock:/var/run/docker.sock"
mounts="$mounts -v $(which docker):$(which docker)"

# Use at most half of all available RAM.
memlimit=$(($(free -g | awk '/^Mem/ { print $2 }') / 2))G

$DOCKER run -dt -p 2222:22 --name=host --hostname=$(hostname)-dckr $mounts --memory=$memlimit --pids-limit=5000 --restart=unless-stopped $image
