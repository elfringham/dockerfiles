#!/bin/bash

set -eu

if [ "${1+set}" = "set" ]; then
  true
else
  echo "Syntax: $0 <dockerfile>" 1>&2
  exit 1
fi

DOCKERFILE=$1

EXPECTED_MD5=$(tail -n1 "$DOCKERFILE" | awk '{ print $3; }')
ACTUAL_MD5=$(head -n -1 "$DOCKERFILE" | md5sum  |awk '{ print $1; }')

if [ "$EXPECTED_MD5" = "$ACTUAL_MD5" ]; then
  true
else
  echo "ERROR: $DOCKERFILE has been modified since it was auto-generated."
  echo "Note: Current dir is $(pwd)"
  exit 1
fi

