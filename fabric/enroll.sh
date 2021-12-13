#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN:?}/util.sh" ""

bash "${__PROJ__}/enroll.sh"

exit 0

## tls --------------------------
#bash "${__PROJ__}/tlsca-admin.sh" || exit 1
#bash "${__PROJ__}/tlsca-register.sh" || exit 1
#bash "${__PROJ__}/tlsca-enroll.sh" || exit 1
#
#
## ca ---------------------------
#bash "${__PROJ__}/ca-admin.sh" || exit 1
#bash "${__PROJ__}/ca-register.sh" || exit 1
#bash "${__PROJ__}/ca-enroll.sh" || exit 1
#
#
## gpn ---------------------------
#bash "${__PROJ__}/gpn.ru/tlsca-register.sh" || exit 1
#bash "${__PROJ__}/gpn.ru/tlsca-enroll.sh" || exit 1
#bash "${__PROJ__}/gpn.ru/ca-register.sh" || exit 1
#bash "${__PROJ__}/gpn.ru/ca-enroll.sh" || exit 1
#
#bash "${__PROJ__}/99-pretty.sh" || exit 1
