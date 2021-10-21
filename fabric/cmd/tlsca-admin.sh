#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

fabric-ca-client enroll -u "https://tlsca-admin:tlsca-adminpw@${__TLSCA_SCR__}" \
  --home "$__TLSCA_ADM_HOME__"

[ $? -ne 0 ] && exit 1

exit 0
