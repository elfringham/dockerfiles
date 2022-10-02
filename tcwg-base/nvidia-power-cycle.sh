#!/bin/bash

case "$*" in
    "tcwg-sq-"*)
	case "$*" in
	    "tcwg-sq-01") port="12" ;;
	    "tcwg-sq-02") port="13" ;;
	    *)
		echo "Unknown board $*"
		exit 1
		;;
	esac
	exec ssh services.tcwglab /usr/local/lab-scripts/snmp_pdu_control --hostname tpdu01 --port $port --command reboot
	;;
    *)
	# nvidia-reset script lives at
	# https://git.linaro.org/lava/lava-lab.git/tree/shared/tcwg-scripts/nvidia-reset
	exec ssh -p22 dev-01.tcwglab nvidia-reset "$*"
	;;
esac
