#!/bin/bash

set -e

usage ()
{
    cat <<EOF
$0 [OPTIONS] -- IMAGE

Options:
  --getent DATA
	User data from "getent passwd"

  --group NAME
	Primary group name

  --name CONTAINER_NAME
	Name of the container

  --pubkey KEY
	SSH public key to install inside container

  --user USER
	Username to create inside the container

  --verbose true/false
	Whether to run in verbose mode
EOF
    exit 1
}

getent="default"
group="default"
name="default"
pubkey="ldap"
user="$USER"
verbose=false

while [ $# -gt 0 ]; do
    case $1 in
	--getent) getent="$2"; shift ;;
	--group) group="$2"; shift ;;
	--name) name="$2"; shift ;;
	--pubkey) pubkey="$2"; shift ;;
	--user) user="$2"; shift ;;
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

if [ x"$name" = x"default" ]; then
    name="$user-$(echo "$image" | tr "/:" "_")"
fi

mounts=""
if [ -d "/home/$user" ]; then
    # Bind-mount $HOME
    mounts="$mounts -v /home/$user:/home/$user"
else
    # Create/re-use docker volume and mount it as user's home
    mounts="$mounts -v home-$user:/home"
fi

if [ -d "/home/tcwg-buildslave" ]; then
    # Bind-mount /home/tcwg-buildslave read-only to get access to
    # /home/tcwg-buildslave/snapshots-ref/
    mounts="$mounts -v /home/tcwg-buildslave:/home/tcwg-buildslave:ro"
fi

# Use at most half of all available RAM.
memlimit=$(($(free -g | awk '/^Mem/ { print $2 }') / 2))G
# IPC_LOCK is required for some implementations of ssh-agent (e.g., MATE's).
# SYS_PTRACE is required for debugger work.
caps="--cap-add=IPC_LOCK --cap-add=SYS_PTRACE"

if [ x"$getent" = x"default" ]; then
    getent=$(getent passwd $user)
fi

if [ x"$group" = x"default" ]; then
    group=$(id -gn $user)
fi

if [ x"$pubkey" = x"ldap" ]; then
    # Fetch ssh public key from LDAP.
    pubkey=$(/etc/ssh/ssh_keys.py $user 2>/dev/null || sss_ssh_authorizedkeys $user 2>/dev/null)
fi

$DOCKER run --name=$name -dt -p 22 $mounts --memory=$memlimit --pids-limit=5000 $caps $image "$getent" "$group" "$pubkey"

port=$($DOCKER port $name 22 | cut -d: -f 2)

set +x
echo "NOTE: the warning about kernel not supporting swap memory limit is expected"
echo "To connect to container run \"ssh -p $port localhost\""
echo "To stop container run \"docker stop $name\""
echo "To restart container run \"docker start $name\""
echo "To remove container run \"docker rm -fv $name\""
echo "See https://collaborate.linaro.org/display/TCWG/How+to+setup+personal+dev+environment+using+docker for additional info"
