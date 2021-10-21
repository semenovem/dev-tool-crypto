#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

LOG_FILE="/tmp/ca-server-tls.txt"

mkdir -p "${__TLSCA_SRV_HOME__}" || exit 1

CFG_SOURCE="${__CFG__}/tlsca-server.yaml"
CFG_DIST="${__TLSCA_SRV_HOME__}/fabric-ca-server-config.yaml"
[ ! -f "$CFG_DIST" ] && cp "$CFG_SOURCE" "$CFG_DIST" && [ $? -ne 0 ] && exit 1
cd "$__TLSCA_SRV_HOME__" || exit 1

fabric-ca-server start \
  -b ca-admin:ca-adminpw \
  --home "$__TLSCA_SRV_HOME__" \
  --port "$__TLSCA_PORT__" \
  --loglevel info \
  --tls.enabled \
  --tls.certfile "$__CONN_SRV_CERT__" \
  --tls.keyfile "$__CONN_SRV_KEY__" \
  --tls.clientauth.certfiles "$__CONN_CA_CERT__" \
  &>"$LOG_FILE" &

sleep 1

cat "$LOG_FILE" || exit 1
grep -i "Listening on http" "$LOG_FILE" || exit 1

exit 0
