#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/util.sh" ""

bash ./inside/clean.sh
bash ./start-ca.sh

# tls --------------------------
bash "${BIN}/cmd/tlsca-admin.sh" || exit 1
bash "${BIN}/cmd/tlsca-register.sh" || exit 1
bash "${BIN}/cmd/tlsca-enroll.sh" || exit 1

# ca ---------------------------
bash "${BIN}/cmd/ca-admin.sh" || exit 1
bash "${BIN}/cmd/ca-affiliation.sh" || exit 1
bash "${BIN}/cmd/ca-register.sh" || exit 1
bash "${BIN}/cmd/ca-enroll.sh" || exit 1

# gpn ---------------------------
bash "${BIN}/cmd/gpn.ru/tlsca-register.sh" || exit 1
bash "${BIN}/cmd/gpn.ru/tlsca-enroll.sh" || exit 1
bash "${BIN}/cmd/gpn.ru/ca-register.sh" || exit 1
bash "${BIN}/cmd/gpn.ru/ca-enroll.sh" || exit 1

bash "${BIN}/cmd/99-pretty.sh"
