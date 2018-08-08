#!/bin/bash

set -e

if [ x"$1" = x"start.sh" ]; then
    cat /start.sh
    exit 0
fi

new-user.sh --update true "$@"

exec /usr/sbin/sshd -D
