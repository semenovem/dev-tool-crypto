#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/util.sh" ""

PIDS=$(ps -fC fabric-ca-serve | awk '{print $2}' | tail -n +2)
for PID in $PIDS; do
  echo "stopping pid = $PID"
  kill -1 "$PID"
done

sleep 3

PIDS=$(ps -fC fabric-ca-serve | awk '{print $2}' | tail -n +2)
for PID in $PIDS; do
  echo "stopping pid = $PID"
  kill -9 "$PID"
done
