#!/bin/bash

resolve_ips()
{
    local i
    while [ "$#" -gt 0 ]; do
	i="$1"
	shift
	# Output the original entry
	echo "$i"
	# Skip entries that are already IPs
	if echo "$i" | grep -q "^[0-9\.]\+\$"; then
	    continue
	fi
	host "$i" | grep ".* has address " | sed -e "s/.* has address //"
    done
}

DEST=$(dirname "$0")/known_hosts

echo "# This file is generated automatically with known_hosts-regen.sh. DO NOT EDIT" > $DEST
(
    hosts=(
	lab.validation.linaro.org
	people.linaro.org
	git.linaro.org
	git-us.linaro.org
	dev-private-git.linaro.org
	review.linaro.org
	dev-private-review.linaro.org
	213.146.141.69  # tcwg-fx-01
	139.178.86.199  # tcwg-jade-01
	139.178.84.209  # tcwg-jade-02
	139.178.84.207  # tcwg-jade-03
	147.75.199.202  # linaro-armv8-01
	147.75.55.170   # tcwg-amp-01
	139.178.86.246  # tcwg-amp-02
	147.75.55.190   # tcwg-amp-03
	139.178.85.170  # tcwg-amp-04
	147.75.92.162   # tcwg-amp-05
	147.75.92.166   # tcwg-amp-06
	147.75.106.138  # tcwg-d05-01
	148.251.136.42  # tcwg-ex40-01
    )
    ssh-keyscan -t rsa,dsa,ecdsa $(resolve_ips "${hosts[@]}")

    hosts=(
	review.linaro.org
	dev-private-review.linaro.org
    )
    ssh-keyscan -p29418 -t rsa,dsa,ecdsa $(resolve_ips "${hosts[@]}")

    hosts=(
	ci.linaro.org
    )
    ssh-keyscan -p2020 -t rsa,dsa,ecdsa $(resolve_ips "${hosts[@]}")

    hosts=(
	ci.linaro.org
    )
    ssh-keyscan -p2222 -t rsa,dsa,ecdsa $(resolve_ips "${hosts[@]}")
) | sort -u >> $DEST
