#!/bin/sh

set -e

export HOME=/home/buildslave

[ -z "${JENKINS_SLAVE_SSH_PUBKEY}" ] || {
  mkdir ${HOME}/.ssh
  echo "${JENKINS_SLAVE_SSH_PUBKEY}" > ${HOME}/.ssh/authorized_keys
  chown -R buildslave:buildslave ${HOME}/.ssh
  chmod 0700 -R ${HOME}/.ssh
}

. /opt/ros/kinetic/setup.sh
env | grep ROS_ >> /etc/environment
env | grep PATH >> /etc/environment

ssh-keygen -A
exec /usr/sbin/sshd -D -e
