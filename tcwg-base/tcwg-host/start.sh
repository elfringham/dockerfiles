#!/bin/bash

set -e

usage ()
{
    cat <<EOF
$0 [OPTIONS] -- IMAGE GROUP

Options:
  --task host/jenkins
	Task to serve: "host" is for all users, "jenkins" is for tcwg-infra

  --verbose true/false
	Whether to run in verbose mode
EOF
    exit 1
}

task="host"
verbose=false

while [ $# -gt 0 ]; do
    case $1 in
	--task) task="$2"; shift ;;
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
case "$task" in
    host)
	;;
    jenkins)
	if [ x"$group" != x"tcwg-infra" ]; then
	    echo "ERROR: group for task $task should be tcwg-infra"
	    exit 1
	fi
	;;
    *)
	echo "ERROR: wrong task $task"
	exit 1
	;;
esac

mounts=""
mounts="$mounts -v host-home:/home"
mounts="$mounts -v /var/run/docker.sock:/var/run/docker.sock"
mounts="$mounts -v /usr/bin/docker:/usr/bin/docker"

# Use at most half of all available RAM.
memlimit=$(free -m | awk '/^Mem/ { print $2 }')
memlimit=$(($memlimit / 2))m

$DOCKER run -dt --name=$task --network host --restart=unless-stopped $mounts --memory=$memlimit --pids-limit=5000 $image "$group" "$task"
