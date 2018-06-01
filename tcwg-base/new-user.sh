#!/bin/bash

set -euf -o pipefail

usage ()
{
    exit 1
}

passwd_ent=""
group=""
key=""
user=""
verbose=false

while [ $# -gt 0 ]; do
    case "$1" in
	--passwd) passwd_ent="$2" ;;
	--group) group="$2" ;;
	--key) key="$2" ;;
	--user) user="$2" ;;
	--verbose) verbose="$2"; shift ;;
	*) echo "ERROR: Wrong option: $1"; usage ;;
    esac
    shift 2
done

if $verbose; then set -x; fi

if [ x"$group" != x"" ]; then
    gid=$(echo "$group" | cut -s -d: -f 2)
    group=$(echo "$group" | cut -d: -f 1)

    if [ x"$gid" != x"" ]; then
	groupadd -g $gid $group
    fi

    group_opt="-g $group"
elif [ x"$passwd_ent" != x"" ]; then
    gid=$(echo $passwd_ent | cut -d: -f 4)
    group_opt="-g $gid"
else
    group_opt=""
fi

if [ x"$user" = x"" ]; then
    user=$(echo "$passwd_ent" | cut -s -d: -f 1,3)
fi

uid=$(echo "$user" | cut -s -d: -f 2)
user=$(echo "$user" | cut -d: -f 1)

if [ x"$user" != x"" ]; then
    if [ x"$passwd_ent" != x"" ]; then
	comment=$(echo $passwd_ent | cut -d: -f 5)
	shell=$(echo $passwd_ent | cut -d: -f 7)
    fi

    useradd -m $group_opt -G kvm \
	    ${uid:+-u $uid} \
	    ${comment:+-c "$comment"} \
	    ${shell:+-s "$shell"} \
	    $user

    sudoers_file=/etc/sudoers.d/$(echo $user | tr "." "-")
    echo "$user ALL = NOPASSWD: ALL" > $sudoers_file
    chmod 0440 $sudoers_file
fi

if [ x"$key" != x"" ]; then
    key_user=$(echo "$key" | sed -e "s/.*authorized_keys-//")
    sudo -i -u $key_user mkdir -p /home/$key_user/.ssh
    sudo -i -u $key_user chmod 0700 /home/$key_user/.ssh
    cat "$key" | sudo -i -u $key_user tee /home/$key_user/.ssh/authorized_keys > /dev/null
    sudo -i -u $key_user chmod 0600 /home/$key_user/.ssh/authorized_keys
fi
