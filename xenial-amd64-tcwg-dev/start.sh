#!/bin/bash

set -e
set -x

if groups tcwg-buildslave 2>/dev/null | grep -q docker; then
    # If tcwg-buildslave user is present, use it to start the container
    # to have [sudo] log record of container startups.
    DOCKER="sudo -u tcwg-buildslave docker"
elif groups 2>/dev/null | grep -q docker; then
    # Run docker straight up if $USER is in "docker" group.
    DOCKER="docker"
else
    # Fallback to sudo otherwise.
    DOCKER="sudo docker"
fi

$DOCKER pull linaro/dev-amd64-tcwg-dev-ubuntu:xenial
$DOCKER run --name=$USER-xenial -dt -p 22 -v $HOME:$HOME -v /home/tcwg-buildslave:/home/tcwg-buildslave:ro --memory=$(($(free -g | awk '/^Mem/ { print $2 }') / 2))G --pids-limit=5000 --cap-add=IPC_LOCK linaro/dev-amd64-tcwg-dev-ubuntu:xenial "$(getent passwd $USER)" "$(id -gn)" "$(/etc/ssh/ssh_keys.py $USER 2>/dev/null || sss_ssh_authorizedkeys $USER 2>/dev/null)"

port=$($DOCKER port $USER-xenial 22 | cut -d: -f 2)

set +x
echo "NOTE: the warning about kernel not supporting swap memory limit is expected"
echo "To connect to container run \"ssh -p $port localhost\""
echo "To stop container run \"docker stop $USER-xenial\""
echo "To restart container run \"docker start $USER-xenial\""
echo "To remove container run \"docker rm -fv $USER-xenial\""
echo "See https://collaborate.linaro.org/display/TCWG/How+to+setup+personal+dev+environment+using+docker for additional info"
