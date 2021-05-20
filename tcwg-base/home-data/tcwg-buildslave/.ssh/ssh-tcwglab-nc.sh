#!/bin/sh

if grep -q "nameserver 192.168.16.3" /etc/resolv.conf; then
    # If we are in one of TCWG Cambridge subnetworks, then use straight nc.
    exec nc "$@"
else
    # Otherwise jump from ci.linaro.org and bkp-01.tcwglab
    exec ssh -Snone -A ci.linaro.org ssh -Snone bkp-01.tcwglab.linaro.org nc "$@"
fi
