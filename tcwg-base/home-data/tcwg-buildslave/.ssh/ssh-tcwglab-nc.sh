#!/bin/sh

if ip addr show 2>&1 | grep -q "inet 192\.168\.1[678]\."; then
    # If we are in one of TCWG Cambridge subnetworks, then use straight nc.
    exec nc "$@"
else
    # Otherwise jump from ci.linaro.org
    exec ssh -Snone ci.linaro.org nc "$@"
fi
