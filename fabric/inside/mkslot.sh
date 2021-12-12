#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

if [ "$__BCCSP_DEFAULT__" = "PKCS11" ]; then

  if [ ! -d "$__SOFTHSM_TOKENS__" ]; then
    mkdir -p "$__SOFTHSM_TOKENS__" || exit 1
  fi

  if [ ! -f "$__SOFTHSM_CONF__" ]; then
    D=$(dirname "$__SOFTHSM_CONF__")

    mkdir -p "$D" || exit 1
    cp "$__SOFTHSM_CONF_TMPL__" "$__SOFTHSM_CONF__"
  fi

  softhsm2-util --init-token --slot 0 \
    --label "$__HSM_SLOT__" \
    --pin "$__HSM_PIN__" \
    --so-pin 1212
fi
