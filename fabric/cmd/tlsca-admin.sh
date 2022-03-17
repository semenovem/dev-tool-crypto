#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

dir-empty "$__TLSCA_ADM_HOME__" || exit 0
mkdir -p "$__TLSCA_ADM_HOME__" || exit 1

CFG_SOURCE="${__CFG__}/tlsca-admin.yaml"
CFG_DIST="${__TLSCA_ADM_HOME__}/fabric-ca-client-config.yaml"
[ ! -f "$CFG_DIST" ] && (cp "$CFG_SOURCE" "$CFG_DIST" || exit 1)
cd "$__TLSCA_ADM_HOME__" || exit 1

fabric-ca-client enroll -u "https://tlsca-admin:tlsca-adminpw@${__TLSCA_SCR__}" \
  --home "$__TLSCA_ADM_HOME__"
