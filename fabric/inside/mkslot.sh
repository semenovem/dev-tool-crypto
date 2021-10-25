#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

if [ ! -d "$__SOFTHSM_TOKENS__" ]; then
  mkdir -p "$__SOFTHSM_TOKENS__" || exit 1

  softhsm2-util --init-token --slot 0 \
    --label "$__HSM_SLOT__" \
    --pin "$__HSM_PIN__" \
    --so-pin 1212
fi
