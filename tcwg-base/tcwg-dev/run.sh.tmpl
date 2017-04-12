#!/bin/bash

set -e

if [ x"$@" = x"start.sh" ]; then
    cat /start.sh
    exit 0
fi

if ! [ -f /etc/sudoers.d/user ]; then
    passwd_ent="$1"
    groupname="$2"
    pubkey="$3"

    username="$(echo $passwd_ent | cut -d: -f 1)"
    uid="$(echo $passwd_ent | cut -d: -f 3)"
    gid="$(echo $passwd_ent | cut -d: -f 4)"
    comment="$(echo $passwd_ent | cut -d: -f 5)"
    home="$(echo $passwd_ent | cut -d: -f 6)"
    shell="$(echo $passwd_ent | cut -d: -f 7)"

    groupadd -g "$gid" "$groupname"
    useradd -m -u "$uid" -g "$groupname" -c "$comment" -s "$shell" "$username"

    if ! [ -f /home/$username/.ssh/authorized_keys.docker ] \
	    && [ x"$pubkey" != x"" ]; then
	sudo -u $username mkdir -p /home/$username/.ssh/
	echo "$pubkey" | sudo -u $username tee /home/$username/.ssh/authorized_keys.docker > /dev/null
    fi

    echo "$username ALL = NOPASSWD: ALL" > /etc/sudoers.d/user
    chmod 440 /etc/sudoers.d/user
fi

exec /usr/sbin/sshd -D
