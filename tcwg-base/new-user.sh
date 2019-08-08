#!/bin/bash

set -euf -o pipefail

usage ()
{
    exit 1
}

passwd_ent=""
group=""
home_data="default"
update=false
user=""
verbose=false

while [ $# -gt 0 ]; do
    case "$1" in
	--passwd) passwd_ent="$2" ;;
	--group) group="$2" ;;
	--home-data) home_data="$2" ;;
	--update) update="$2" ;;
	--user) user="$2" ;;
	--verbose) verbose="$2" ;;
	*) echo "ERROR: Wrong option: $1"; usage ;;
    esac
    shift 2
done

if $verbose; then set -x; fi

if [ x"$home_data" = x"default" ]; then
    home_data=""
    if [ -d /home-data/ ]; then
	home_data="/home-data"
    fi
fi

if [ x"$passwd_ent" = x"" -a x"$home_data" != x"" -a x"$user" != x"" ]; then
    passwd_ent=$(grep "^${user%%:*}:" "$home_data/passwd")
fi

if [ x"$group" != x"" ]; then
    gid=$(echo "$group" | cut -s -d: -f 2)
    group=$(echo "$group" | cut -d: -f 1)

    if [ x"$gid" != x"" ]; then
	action="add"
	if $update && getent group $group >/dev/null; then
	    action="mod"
	fi
	group${action} -g $gid $group
    fi

    group_opt="-g $group"
elif [ x"$passwd_ent" != x"" ]; then
    gid=$(echo "$passwd_ent" | cut -d: -f 4)
    group_opt="-g $gid"
else
    group_opt=""
    gid=""
fi

if [ x"$user" = x"" ]; then
    user=$(echo "$passwd_ent" | cut -s -d: -f 1,3)
fi

uid=$(echo "$user" | cut -s -d: -f 2)
user=$(echo "$user" | cut -d: -f 1)

if [ x"$uid" = x"" -a x"$passwd_ent" != x"" ]; then
    uid=$(echo "$passwd_ent" | cut -d: -f 3)
fi

if [ x"$user" != x"" ]; then
    if [ x"$passwd_ent" != x"" ]; then
	comment=$(echo "$passwd_ent" | cut -d: -f 5)
	shell=$(echo "$passwd_ent" | cut -d: -f 7)
    fi

    aux_groups="kvm"
    if [ x"$home_data" != x"" ]; then
	for g in $(grep "$user" "$home_data/group" | cut -d: -f 1); do
	    if [ x"$g" = x"$group" ]; then
		continue
	    fi
	    aux_groups="$aux_groups,$g"
	done
    fi

    action="add"
    if $update && getent passwd $user >/dev/null; then
	action="mod"
    fi
    user${action} $group_opt -G $aux_groups \
	    -m -d /home/$user \
	    ${uid:+-u $uid} \
	    ${comment:+-c "$comment"} \
	    ${shell:+-s "$shell"} \
	    $user

    sudoers_file=/etc/sudoers.d/$(echo $user | tr "." "-")
    echo "$user ALL = NOPASSWD: ALL" > $sudoers_file
    chmod 0440 $sudoers_file

    if [ x"$home_data" != x"" ]; then
	chown -R $user${gid:+:$gid} $home_data/$user/
	chmod -R go-w $home_data/$user/
	chmod -R go-rwx $home_data/$user/.ssh/
	rsync -ab $home_data/$user/ /home/$user/
    fi
fi
