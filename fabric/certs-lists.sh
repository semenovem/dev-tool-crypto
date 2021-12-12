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
[ -z "$ON" ] && echo -e "use: $0 [tls|msp]"

[ -z $2 ] &&
  echo -e \
    "Flags:
      --aki string          Get certificates for this AKI
      --expiration string   Get certificates which expire between the UTC timestamp (RFC3339 format) or duration specified (e.g. <begin_time>::<end_time>)
  -h, --help                help for list
      --id string           Get certificates for this enrollment ID
      --notexpired          Don't return expired certificates
      --notrevoked          Don't return revoked certificates
      --revocation string   Get certificates that were revoked between the UTC timestamp (RFC3339 format) or duration specified (e.g. <begin_time>::<end_time>)
      --serial string       Get certificates for this serial number
      --store string        Store requested certificates in this location"

shift

[ $2 ] && fabric-ca-client certificate list $@
