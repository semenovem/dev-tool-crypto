#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")

ARG=$1
IMG=ub-locale-ru:1

case $ARG in
"build" | "-build")
  docker build -f ./Dockerfile -t "$IMG" .
  ;;
"run" | "-run")
  docker run -it --rm -w /app -v "${BIN}:/app" $IMG bash

  ;;
*) echo "use [build | run]" ;;
esac
