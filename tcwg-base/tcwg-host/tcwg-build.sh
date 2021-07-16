#!/bin/bash

set -euf -o pipefail

# Helper script to quickly enter CI build containers.

if [ $# != 0 ]; then
    grep=(grep "$@")
else
    grep=(grep "^[0-9]\+-")
fi

cnt=($(docker ps --format "{{.Names}}" | "${grep[@]}"))

if [ "${#cnt[@]}" != 1 ]; then
    echo "ERROR: Containers matching '${grep[*]}':"
    printf "%s\n" "${cnt[@]}"
    echo "ERROR: Must be exactly one matching container"
    exit 1
fi

cmd=(docker exec -it "${cnt[@]}" su - tcwg-buildslave)
echo "${cmd[@]}"
exec "${cmd[@]}"
