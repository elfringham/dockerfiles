#!/bin/bash

set -e

usage ()
{
    cat <<EOF
$0 [OPTIONS] -- IMAGE [NEW_USER_PARAMS]

Options:
  --home volume/bind
	How to mount /home; default is volume home-$user

  --name CONTAINER_NAME
	Name of the container

  --user USER
	Username to create inside the container

  --verbose true/false
	Whether to run in verbose mode
EOF
    exit 1
}

home="volume"
name="default"
user="$USER"
verbose=false

while [ $# -gt 0 ]; do
    case $1 in
	--home) home="$2"; shift ;;
	--name) name="$2"; shift ;;
	--user) user="$2"; shift ;;
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

if [ x"$name" = x"default" ]; then
    name="$user-$(echo "$image" | tr "/:" "_")"
fi

mounts=""

docker_host=false
if [ -f "/.dockerenv" ] && mount | grep -q "/run/docker.sock "; then
    docker_host=true
fi

home_top="/home"
if $docker_host; then
    # If inside "host" container (with proxied docker and /home from host-home
    # volume), convert paths to refer to volume's path on bare-metal.
    home_top=/var/lib/docker/volumes/host-home/_data
fi

if $docker_host || [ -d "$home_top/tcwg-buildslave" ]; then
    # Bind-mount /home/tcwg-buildslave read-only to get access to
    # /home/tcwg-buildslave/snapshots-ref/
    mounts="$mounts -v $home_top/tcwg-buildslave:/home/tcwg-buildslave:ro"
fi

case "$home" in
    bind)
	# Bind-mount $HOME
	mounts="$mounts -v $home_top/$user:/home/$user"
	;;
    volume)
	# Create/re-use docker volume and mount it as user's home
	mounts="$mounts -v home-$user:/home"
	;;
esac

# Use at most half of all available RAM.
memlimit=$(($(free -g | awk '/^Mem/ { print $2 }') / 2))G
# IPC_LOCK is required for some implementations of ssh-agent (e.g., MATE's).
# SYS_PTRACE is required for debugger work.
caps="--cap-add=IPC_LOCK --cap-add=SYS_PTRACE"

$DOCKER run --name=$name --hostname=$(hostname)-dev --restart=unless-stopped -dt -p 22 $mounts --memory=$memlimit --pids-limit=5000 $caps $image --user $user "$@"

port=$($DOCKER port $name 22 | cut -d: -f 2)
hostname=$(echo ${SSH_CONNECTION} | { read client_ip client_port server_ip server_port; echo $server_ip; })

set +x
cat <<EOF
NOTE: the warning about kernel not supporting swap memory limit is expected
To connect to the container run "ssh -p $port $user@$hostname" from your local
machine.
To stop container run "docker stop $name"
To restart container run "docker start $name"
To remove container run "docker rm -fv $name"
See https://collaborate.linaro.org/display/TCWG/How+to+setup+personal+dev+environment+using+docker for additional info
EOF
