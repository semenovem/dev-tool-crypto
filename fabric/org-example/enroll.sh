#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

# tls --------------------------
bash "${BIN}/tlsca-admin.sh" || exit 1
bash "${BIN}/tlsca-register.sh" || exit 1
bash "${BIN}/tlsca-enroll.sh" || exit 1


# ca ---------------------------
bash "${BIN}/ca-admin.sh" || exit 1
bash "${BIN}/ca-register.sh" || exit 1
bash "${BIN}/ca-enroll.sh" || exit 1


## gpn ---------------------------
#bash "${__PROJ__}/gpn.ru/tlsca-register.sh" || exit 1
#bash "${__PROJ__}/gpn.ru/tlsca-enroll.sh" || exit 1
#bash "${__PROJ__}/gpn.ru/ca-register.sh" || exit 1
#bash "${__PROJ__}/gpn.ru/ca-enroll.sh" || exit 1

bash "${BIN}/99-pretty.sh" || exit 1
