#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/util.sh" ""

TYPE=$1
ON=

if [ "$TYPE" = "tls" ]; then
  echo "--- tls"
  export FABRIC_CA_CLIENT_HOME="$__TLSCA_ADM_HOME__"
  ON=1
fi

if [ "$TYPE" = "msp" ]; then
  echo "--- msp"
  export FABRIC_CA_CLIENT_HOME="$__CA_ADM_HOME__"
  export FABRIC_CA_CLIENT_BCCSP_DEFAULT="$__BCCSP_DEFAULT__"
  ON=1
fi
[ -z "$ON" ] && echo -e "use: $0 [tls|msp]
  Flags:
    --id string   Get identity information from the fabric-ca server"

[ "$ON" ] && shift && fabric-ca-client identity list $@
