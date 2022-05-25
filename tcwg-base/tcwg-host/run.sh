#!/bin/bash

set -e

if [ x"$1" = x"start.sh" ]; then
    cat /start.sh
    exit 0
fi

group="$1"
node="$2"

if [ x"$group" = x"all" ]; then
    group=".*"
    root_group="tcwg-root"
elif grep -q "^$group-root:x:x:" /home-data/group; then
    root_group="$group-root"
else
    root_group="tcwg-root"
fi

root_users=""

while read line; do
    user=$(echo "$line" | cut -d: -f 1)
    if grep "^$group:x:[0-9]" /home-data/group | cut -d: -f 4 | grep -q "$user,\?"; then
	new-user.sh --update true --passwd "$line" &
	res=0; wait $! || res=$?
	if [ x"$res" != x"0" ]; then
	    echo "WARNING: User configuration failed: $line"
	elif grep "^$root_group:x:x:" /home-data/group | cut -d: -f 4 | grep -q "$user,\?"; then
	    # Make list of users allowed to ssh as root.
	    root_users="$root_users $user"
	fi
    else
	echo "INFO: Not adding user $user because they are not in the group $group."
    fi
done </home-data/passwd

case "$node" in
    host)
	# Install ssh keys of $root_users into root's account.
	# Note that this is intended to grant $root_users root access
	# to the bare machine -- /root is bind-mounted from bare machine
	# to "host" container.
	if ! [ -f /root/.ssh/authorized_keys.orig ]; then
	    if ! [ -f /root/.ssh/authorized_keys ]; then
		if ! [ -d /root/.ssh ]; then
		    mkdir -p /root/.ssh
		    chmod 0700 /root/.ssh
		fi
		touch /root/.ssh/authorized_keys
	    fi
	    mv /root/.ssh/authorized_keys /root/.ssh/authorized_keys.orig
	fi
	key=$(mktemp)
	rm -f $key $key.pub
	if [ x"$(docker inspect --format='{{.HostConfig.Privileged}}' host)" = x"true" ]; then
	    ssh-keygen -f $key -N "" -q
	    sed -i -e "s#@KEY@#$key#" /usr/local/bin/run_on_bare_machine
	fi
	(
	    echo "# Original root keys:"
	    cat /root/.ssh/authorized_keys.orig
	    if [ -f $key.pub ]; then
	        echo "# Temporary key for granting privileged host container access to the bare machine"
		cat $key.pub
	    fi
	    for user in $root_users; do
		echo
		echo "# $user keys:"
		cat /home-data/$user/.ssh/authorized_keys
	    done
	    echo
	) > /root/.ssh/authorized_keys
	# tcwg-start-container.sh needs /root/docker-wrapper to test
	# and recover docker service on benchmarking boards.
	cp /usr/local/bin/docker-wrapper /root/

	# Configure and start ssh server
	sed -i -e "/.*Port.*/d" /etc/ssh/sshd_config
	echo "Port 2222" >> /etc/ssh/sshd_config
	exec /usr/sbin/sshd -D
	;;
    tcwg-bmk-*) user=tcwg-benchmark ;;
    *) user=tcwg-buildslave ;;
esac

sudo -i -u $user rm -rf /home/$user/jenkins-workdir-$node
sudo -i -u $user mkdir /home/$user/jenkins-workdir-$node
sudo -i -u $user curl -o /home/$user/jenkins-workdir-$node/agent.jar \
     https://ci.linaro.org/jnlpJars/agent.jar

exec sudo -i -u $user java -jar /home/$user/jenkins-workdir-$node/agent.jar \
     -jnlpUrl https://ci.linaro.org/computer/$node/slave-agent.jnlp \
     -noReconnect -secret @jenkins/$node.secret \
     -workDir /home/$user/jenkins-workdir-$node
