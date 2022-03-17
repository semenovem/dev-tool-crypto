#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

mkdir -p "$__CA_SRV_HOME__" || exit 1
mkdir -p "$__LOGS_DIR__" || exit 1

CFG_SOURCE="${__CFG__}/ca-server.yaml"
CFG_DIST="${__CA_SRV_HOME__}/fabric-ca-server-config.yaml"
[ ! -f "$CFG_DIST" ] && (cp "$CFG_SOURCE" "$CFG_DIST" || exit 1)
cd "$__CA_SRV_HOME__" || exit 1

export FABRIC_CA_SERVER_DEBUG=false
export FABRIC_CA_SERVER_BCCSP_DEFAULT="$__BCCSP_DEFAULT__"

if [ "$__CA_OPERATIONS_LISTENADDRESS__" ]; then
  export FABRIC_CA_SERVER_OPERATIONS_LISTENADDRESS="127.0.0.1:${__CA_OPERATIONS_LISTENADDRESS__}"
fi

fabric-ca-server start \
  -b ca-admin:ca-adminpw \
  --loglevel debug \
  --home "$__CA_SRV_HOME__" \
  --port "$__CA_PORT__" \
  --tls.enabled \
  --tls.certfile "$__CONN_SRV_CERT__" \
  --tls.keyfile "$__CONN_SRV_KEY__" \
  --tls.clientauth.certfiles "$__CONN_CA_CERT__" \
  --csr.cn "ca.vtb.ru" \
  --csr.keyrequest.algo "ecdsa" \
  --csr.keyrequest.size 384 \
  --csr.hosts "0.0.0.0" \
  &>"$__CA_LOG__" &

sleep 1

cat "$__CA_LOG__" || exit 1
grep -i "Listening on http" "$__CA_LOG__"
