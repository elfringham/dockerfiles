#!/bin/bash

set -e

if [ x"$1" = x"start.sh" ]; then
    cat /start.sh
    exit 0
fi

group="$1"
task="$2"

if [ x"$group" = x"all" ]; then
    group=".*"
fi

while read line; do
    user=$(echo "$line" | cut -d: -f 1)
    if grep "^$group:x:" /home-data/group | cut -d: -f 4 | grep -q "$user,\?"; then
	new-user.sh --update true --passwd "$line" &
	res=0; wait $! || res=$?
	if [ x"$res" = x"0" ]; then
	    echo "WARNING: User configuration failed: $line"
	fi
    fi
done </home-data/passwd

port="2222"
if [ x"$task" = x"jenkins" ]; then
    port="2022"
fi

sed -i -e "/.*Port.*/d" /etc/ssh/sshd_config
echo "Port $port" >> /etc/ssh/sshd_config

exec /usr/sbin/sshd -D
