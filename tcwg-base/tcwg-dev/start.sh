#!/bin/bash

set -e

usage ()
{
    cat <<EOF
$0 [OPTIONS] -- IMAGE [NEW_USER_PARAMS]

Options:
  --name CONTAINER_NAME
	Name of the container

  --user USER
	Username to create inside the container

  --verbose true/false
	Whether to run in verbose mode
EOF
    exit 1
}

name="default"
user="$USER"
verbose=false

while [ $# -gt 0 ]; do
    case $1 in
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

if [ x"$name" = x"default" ]; then
    name="$user-$(echo "$image" | tr "/:" "_")"
fi

mounts=""

# Bind-mount $HOME
mounts="$mounts -v /home/$user:/home/$user"
# Bind-mount /home/tcwg-buildslave read-only to get access to
# /home/tcwg-buildslave/snapshots-ref/
if [ -d "/home/tcwg-buildslave" ]; then
    mounts="$mounts -v /home/tcwg-buildslave:/home/tcwg-buildslave:ro"
fi
# Bind-mount ssh host keys.
for key in /etc/ssh/ssh_host_*_key{,.pub}; do
    mounts="$mounts -v $key:$key:ro"
done

# If possible, directly check the kernel config to see if KVM is enabled.
if [ -f /proc/config.gz ] && zgrep -q -e '^CONFIG_KVM=[ym]' /proc/config.gz; then
    HOST_HAS_KVM=true
# Otherwise, check if it's a stock Ubuntu kernel. Those have KVM enabled.
elif uname -v | grep -q -- -Ubuntu; then
    HOST_HAS_KVM=true
# Otherwise, assume that the host doesn't have /dev/kvm.
else
    HOST_HAS_KVM=false
fi

# Allow KVM use within the container.
if [ "$HOST_HAS_KVM" = "true" ]; then
    mounts="$mounts --device=/dev/kvm"
fi

# Use at most half of all available RAM.
memlimit=$(free -m | awk '/^Mem/ { print $2 }')
memlimit=$(($memlimit / 2))m

# IPC_LOCK is required for some implementations of ssh-agent (e.g., MATE's).
# SYS_PTRACE is required for debugger work.
# seccomp=unconfined to allow disabling of ASLR for sanitizer regression tests.
caps="--cap-add=IPC_LOCK --cap-add=SYS_PTRACE --security-opt seccomp:unconfined"

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
