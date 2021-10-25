#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

LOG_FILE="/tmp/ca-server-msp.txt"

mkdir -p "$__CA_SRV_HOME__" || exit 1

CFG_SOURCE="${__CFG__}/ca-server.yaml"
CFG_DIST="${__CA_SRV_HOME__}/fabric-ca-server-config.yaml"
[ ! -f "$CFG_DIST" ] && cp "$CFG_SOURCE" "$CFG_DIST" && [ $? -ne 0 ] && exit 1
cd "$__CA_SRV_HOME__" || exit 1

export FABRIC_CA_SERVER_DEBUG=false
export FABRIC_CA_SERVER_OPERATIONS_LISTENADDRESS=127.0.0.1:9444
export FABRIC_CA_SERVER_BCCSP_DEFAULT=PKCS11

fabric-ca-server start \
  -b ca-admin:ca-adminpw \
  --loglevel info \
  --home "$__CA_SRV_HOME__" \
  --port "$__CA_PORT__" \
  --tls.enabled \
  --tls.certfile "$__CONN_SRV_CERT__" \
  --tls.keyfile "$__CONN_SRV_KEY__" \
  --tls.clientauth.certfiles "$__CONN_CA_CERT__" \
  --csr.cn "ca.vtb.ru" \
  --csr.keyrequest.algo "ecdsa" \
  --csr.keyrequest.size 256 \
  --csr.hosts "0.0.0.0" \
  &>"$LOG_FILE" &

sleep 1

cat "$LOG_FILE" || exit 1
grep -i "Listening on http" "$LOG_FILE" || exit 1
