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
fi

while read line; do
    user=$(echo "$line" | cut -d: -f 1)
    if grep "^$group:x:" /home-data/group | cut -d: -f 4 | grep -q "$user,\?"; then
	new-user.sh --update true --passwd "$line" &
	res=0; wait $! || res=$?
	if [ x"$res" != x"0" ]; then
	    echo "WARNING: User configuration failed: $line"
	fi
    fi
done </home-data/passwd

case "$node" in
    host)
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
