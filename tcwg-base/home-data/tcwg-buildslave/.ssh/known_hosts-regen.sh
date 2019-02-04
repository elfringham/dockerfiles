#!/bin/bash

DEST=$(dirname "$0")/known_hosts

echo "# This file is generated automatically with known_hosts-regen.sh. DO NOT EDIT" > $DEST
(
    hosts=(
	ex40-01.tcwglab.linaro.org
	aus-colo.linaro.org
	lab.validation.linaro.org
	people.linaro.org
	git.linaro.org
	git-us.linaro.org
	dev-private-git.linaro.org
	review.linaro.org
	dev-private-review.linaro.org
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
