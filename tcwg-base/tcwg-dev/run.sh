#!/bin/bash

set -e

if [ x"$1" = x"start.sh" ]; then
    cat /start.sh
    exit 0
fi

new-user.sh --update true "$@"

# /dev/kvm has a random group within the container. Fix it.
if [ -c /dev/kvm ]; then
    chgrp tcwg-users /dev/kvm
fi

exec /usr/sbin/sshd -D
