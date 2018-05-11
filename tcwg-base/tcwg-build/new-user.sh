#!/bin/bash

set -euf -o pipefail

usage ()
{
    exit 1
}

group=""
key=""
user=""
verbose=false

while [ $# -gt 0 ]; do
    case "$1" in
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
else
    group_opt=""
fi

uid=$(echo "$user" | cut -s -d: -f 2)
user=$(echo "$user" | cut -d: -f 1)

useradd -m $group_opt -G kvm ${uid:+-u $uid} $user

sudoers_file=/etc/sudoers.d/$(echo $user | tr "." "-")
echo '$user ALL = NOPASSWD: ALL' > $sudoers_file
chmod 0440 $sudoers_file

if [ x"$key" != x"" ] ; then
    sudo -i -u $user mkdir -p /home/$user/.ssh
    sudo -i -u $user chmod 0700 /home/$user/.ssh
    cat "$key" | sudo -i -u $user tee /home/$user/.ssh/authorized_keys > /dev/null
    sudo -i -u $user chmod 0600 /home/$user/.ssh/authorized_keys
fi
