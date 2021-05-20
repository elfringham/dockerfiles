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
	147.75.92.162   # tcwg-amp-05
	147.75.92.166   # tcwg-amp-06
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

    # Finally, hard-code bkp-01.tcwglab's keys, because its ssh port is
    # accessible only from ci.linaro.org's IP.
    cat <<EOF
# bkp-01.tcwglab.linaro.org:22 SSH-2.0-OpenSSH_7.6p1 Ubuntu-4ubuntu0.3
bkp-01.tcwglab.linaro.org ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfJTJpNI5XQJawxfTHN0/D4CVZQoHm5hXizOleND8BAELbjlwU3+Xru8OFXPcANPj8THnbeWA5H2/DD6Fr8zu74Jc5+nHSotssSpsNHlqV/H/CkAQlHLT5YnMrD9u5RCVK3q3reHmzl/GXVB+3/Gwm/TGemdesIz2lzdUQ4WNRKCVDxAbJoSg0+J+mX0CQhxBeYBre3/J/hlhhdU7IGcYVEFEGkJjrK15QqOJftdOCiQWyj7vLTxjcqKh1KgOXrA8KJltjlbyWzSeN5Z9gY+wmLV/105Ed09XjcelYaz3IzKHPpkdRYwB/NXJ6vJkYSyM9IsWIXyTs/iNNzqgoEqU3
# bkp-01.tcwglab.linaro.org:22 SSH-2.0-OpenSSH_7.6p1 Ubuntu-4ubuntu0.3
bkp-01.tcwglab.linaro.org ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBA5AV6b3iGfuCZbQJb3woinW7oJfKXPZTcABlTA1Pbp1gJD/oQ1+om8iiuEx9n3AkrMCMGwAeiJyNLHqwNcG9Y8=
# bkp-01.tcwglab.linaro.org:22 SSH-2.0-OpenSSH_7.6p1 Ubuntu-4ubuntu0.3
# 51.148.40.55:22 SSH-2.0-OpenSSH_7.6p1 Ubuntu-4ubuntu0.3
# 51.148.40.55:22 SSH-2.0-OpenSSH_7.6p1 Ubuntu-4ubuntu0.3
51.148.40.55 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfJTJpNI5XQJawxfTHN0/D4CVZQoHm5hXizOleND8BAELbjlwU3+Xru8OFXPcANPj8THnbeWA5H2/DD6Fr8zu74Jc5+nHSotssSpsNHlqV/H/CkAQlHLT5YnMrD9u5RCVK3q3reHmzl/GXVB+3/Gwm/TGemdesIz2lzdUQ4WNRKCVDxAbJoSg0+J+mX0CQhxBeYBre3/J/hlhhdU7IGcYVEFEGkJjrK15QqOJftdOCiQWyj7vLTxjcqKh1KgOXrA8KJltjlbyWzSeN5Z9gY+wmLV/105Ed09XjcelYaz3IzKHPpkdRYwB/NXJ6vJkYSyM9IsWIXyTs/iNNzqgoEqU3
# 51.148.40.55:22 SSH-2.0-OpenSSH_7.6p1 Ubuntu-4ubuntu0.3
51.148.40.55 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBA5AV6b3iGfuCZbQJb3woinW7oJfKXPZTcABlTA1Pbp1gJD/oQ1+om8iiuEx9n3AkrMCMGwAeiJyNLHqwNcG9Y8=
EOF
) | sort -u >> $DEST
