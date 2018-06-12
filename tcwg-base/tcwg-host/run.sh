#!/bin/bash

set -e

if [ x"$1" = x"start.sh" ]; then
    cat /start.sh
    exit 0
fi

case "$1" in
    "all")
	while read line; do
	    new-user.sh --update true --passwd "$line"
	done </home-data/passwd
	;;
    *)
	echo "ERROR: Unknown group $1"
	exit 1
	;;
esac

exec /usr/sbin/sshd -D
