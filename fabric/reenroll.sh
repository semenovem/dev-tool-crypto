#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/util.sh" ""

rm -rf "${__CRYPTO__:?}/"* || exit 1

#export REENROLL=reenroll

# tls --------------------------
bash "${BIN}/cmd/tlsca-admin.sh" || exit 1
bash "${BIN}/cmd/tlsca-enroll.sh" || exit 1

# ca ---------------------------
bash "${BIN}/cmd/ca-admin.sh" || exit 1
bash "${BIN}/cmd/ca-enroll.sh" || exit 1

bash "${BIN}/99-pretty.sh"
