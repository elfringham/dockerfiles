#!/bin/bash

case "$*" in
  "llvm-tk1-01") port="7001" ;;
  "llvm-tk1-02") port="7002" ;;
  "llvm-tk1-03") port="7003" ;;
  "llvm-tk1-04") port="7004" ;;
  "llvm-tk1-05") port="7005" ;;
  "llvm-tk1-06") port="7006" ;;
  "llvm-tk1-07") port="7007" ;;
  "llvm-tk1-08") port="7008" ;;
  "llvm-tk1-09") port="7009" ;;
  "tcwg-sq-01")  port="7011" ;;
  "tcwg-sq-02")  port="7012" ;;
  "tcwg-tk1-01") port="7025" ;;
  "tcwg-tk1-02") port="7026" ;;
  "tcwg-tk1-03") port="7027" ;;
  "tcwg-tk1-04") port="7013" ;;
  "tcwg-tk1-05") port="7014" ;;
  "tcwg-tk1-06") port="7015" ;;
  "tcwg-tk1-07") port="7019" ;;
  "tcwg-tk1-08") port="7020" ;;
  "tcwg-tk1-09") port="7021" ;;
  "tcwg-tk1-10") port="7016" ;;
  "tcwg-tx1-01") port="7001" ;;
  "tcwg-tx1-02") port="7002" ;;
  "tcwg-tx1-03") port="7003" ;;
  "tcwg-tx1-04") port="7004" ;;
  "tcwg-tx1-05") port="7005" ;;
  "tcwg-tx1-06") port="7006" ;;
  "tcwg-tx1-07") port="7007" ;;
  "tcwg-tx1-08") port="7008" ;;
  "tcwg-tx1-09") port="7101" ;;
  *)
      echo "Unknown board $*"
      exit 1
esac

case "$*" in
  *"-sq-"*)  serial_host=192.168.16.2 ;;
  *"-tk1-"*) serial_host=192.168.16.255 ;;
  *"-tx1-"*) serial_host=localhost ;;
esac

exec ssh -p22 -t dev-01.tcwglab telnet "$serial_host" "$port"
