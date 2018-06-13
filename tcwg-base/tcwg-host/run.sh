#!/bin/bash

set -e

if [ x"$1" = x"start.sh" ]; then
    cat /start.sh
    exit 0
fi

group="$1"
if [ x"$group" = x"all" ]; then
    group=".*"
fi

while read line; do
    user=$(echo "$line" | cut -d: -f 1)
    if grep "^$group:x:" /home-data/group | cut -d: -f 4 | grep -q "$user,\?"; then
	new-user.sh --update true --passwd "$line"
    fi
done </home-data/passwd

exec /usr/sbin/sshd -D
