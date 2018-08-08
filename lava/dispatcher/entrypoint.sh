#!/usr/bin/env bash
#
# entrypoint.sh
#
# This is the default entrypoint for this image.
#
# By default, it starts lava-slave service with the values set in environment
# variable.
#
# The following environment values can be set:
#
#  HOSTNAME     Name of the slave
#
#  MASTER       Main master socket
#               Example: MASTER='tcp://192.168.1.2:5556'
#
#  SOCKET_ADDR  Log socket
#               Example: SOCKET_ADDR='tcp://192.168.1.2:5555'
#
#  LOG_FILE     Log file for the slave logs
#               Example: LOG_FILE='/tmp/lava-slave.log'
#
#  LOG_LEVEL    Log level (DEBUG, ERROR, INFO, WARN); default to INFO
#               Example: LOG_LEVEL='DEBUG'
#
#  IPV6         Enable IPv6
#               Example: IPV6=True
#
#  ENCRYPT      Encrypt messages
#               Example: ENCRYPT=True
#
#  MASTER_CERT  Master certificate file
#               Example: MASTER_CERT='/etc/lava/certs/master.key'
#
#  SLAVE_CERT   Slave certificate file
#               Example: SLAVE_CERT='/etc/lava/certs/slave.key_secret'
#
# Usages:
#   /entrypoint.sh : starts the lava-slave service with environment variable
#                    values in place.

if [[ -z "${HOSTNAME}" ]];
then
    HOSTNAME=`hostname`
fi

if [[ -z "${MASTER}" ]];
then
    MASTER='tcp://localhost:5556'
fi

if [[ -z "${SOCKET_ADDR}" ]];
then
    SOCKET_ADDR='tcp://localhost:5555'
fi

if [[ -z "${LOG_FILE}" ]];
then
    LOG_FILE=''
else
    LOG_FILE='--log-file '${LOG_FILE}
fi

if [ -z "${LOG_LEVEL}" ]
then
    LOG_LEVEL='INFO'
fi

if [ -z "${ENCRYPT}" ]
then
    ENCRYPT=''
else
    ENCRYPT='--encrypt'
fi

if [ -z "${IPV6}" ]
then
    IPV6=''
else
    IPV6='--ipv6'
fi

if [ -z "${MASTER_CERT}" ]
then
    MASTER_CERT=''
else
    MASTER_CERT='--master-cert '${MASTER_CERT}
fi

if [ -z "${SLAVE_CERT}" ]
then
    SLAVE_CERT=''
else
    SLAVE_CERT='--slave-cert '${SLAVE_CERT}
fi

echo "Starting lava-slave with the following command:"

echo "/usr/bin/python3 /usr/bin/lava-slave --hostname ${HOSTNAME} \
--master ${MASTER} --socket-addr ${SOCKET_ADDR} ${LOG_FILE} \
--level ${LOG_LEVEL} ${ENCRYPT} ${IPV6} ${MASTER_CERT} ${SLAVE_CERT}"

/usr/bin/python3 /usr/bin/lava-slave --hostname ${HOSTNAME} \
--master ${MASTER} --socket-addr ${SOCKET_ADDR} ${LOG_FILE} \
--level ${LOG_LEVEL} ${ENCRYPT} ${IPV6} ${MASTER_CERT} ${SLAVE_CERT}
