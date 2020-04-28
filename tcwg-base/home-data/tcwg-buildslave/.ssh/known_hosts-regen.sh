#!/bin/bash

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
	147.75.199.202  # linaro-armv8-01
	147.75.195.254  # linaro-thx1-01
	147.75.55.170   # tcwg-amp-01
	139.178.86.246  # tcwg-amp-02
	139.178.82.90   # tcwg-amp-03
	139.178.85.170  # tcwg-amp-04
	147.75.106.138  # tcwg-d05-01
	148.251.136.42  # tcwg-ex40-01
	213.146.141.80  # tcwg-m1-01
	213.146.141.115 # tcwg-m1-02
	213.146.141.96  # tcwg-m1-03
	213.146.141.34  # tcwg-m1-04
    )
    ssh-keyscan -t rsa,dsa,ecdsa "${hosts[@]}"

    hosts=(
	review.linaro.org
	dev-private-review.linaro.org
    )
    ssh-keyscan -p29418 -t rsa,dsa,ecdsa "${hosts[@]}"

    hosts=(
	ci.linaro.org
    )
    ssh-keyscan -p2020 -t rsa,dsa,ecdsa "${hosts[@]}"

    hosts=(
	ci.linaro.org
    )
    ssh-keyscan -p2222 -t rsa,dsa,ecdsa "${hosts[@]}"

) | sort -u >> $DEST
