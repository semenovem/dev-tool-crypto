#!/bin/bash

_BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
[ -z "$_BIN" ] && echo "Не определен путь" && exit 1
[ "$1" ] && _BIN="${_BIN}/$1"
[ ! -d "$_BIN" ] && echo "Ошибка определения текущей директории" && exit 1
[ ! -f "${_BIN}/util.sh" ] && echo "Ошибка определения текущей директории" && exit 1

TMP=$(mktemp) || exit 1
grep -Eiv '(^\s*#|^$|^\s*\w+=\s*$)' "${_BIN}/project.properties" > "$TMP" || exit 1

set -o allexport
source "$TMP"
set +o allexport

# флаг разработки
export __PRODUCTION__=
[[ "$PRODUCTION" == "off" ]] && __PRODUCTION__="off"

export __MOUNT_DIR__="$MOUNT_DIR"
export __HSM_LIB__="$HSM_LIB"
export __HSM_SLOT__="$HSM_SLOT"
export __HSM_PIN__="$HSM_PIN"

# Директория для логов удостоверяющих серверов default: logs
export __LOGS_DIR__="${LOGS_DIR:=logs}"

# Порт сервера удостоверяющего центра TLS default 7051
export __TLSCA_PORT__="${TLSCA_PORT:=7051}"

# Порт сервера удостоверяющего центра CA (msp) default 7053
export __CA_PORT__="${CA_PORT:=7053}"

# Хранение ключевой информации [PKCS11 | SW]
export __BCCSP_DEFAULT__="${BCCSP_DEFAULT:=SW}"

# --------------------------
[[ "$__MOUNT_DIR__" != /* ]] && __MOUNT_DIR__="${_BIN}/${__MOUNT_DIR__}"
[[ "$__LOGS_DIR__" != /* ]] && __LOGS_DIR__="${_BIN}/${__LOGS_DIR__}"

ERR=""
[ -z "$__MOUNT_DIR__" ] && echo "Не установлено значение MOUNT_DIR" && ERR=1
if [[ "$__BCCSP_DEFAULT__" == "PKCS11" ]]; then
  [ -z "$__HSM_LIB__" ] && echo "Не установлено значение HSM_LIB" && ERR=1
  [ -z "$__HSM_SLOT__" ] && echo "Не установлено значение HSM_SLOT" && ERR=1
  [ -z "$__HSM_PIN__" ] && echo "Не установлено значение HSM_PIN" && ERR=1
fi

[ -n "$ERR" ] && exit 1

export PATH="${_BIN}/bin.1.4.9:/bin-fabric-ca:${PATH}"

export __CRYPTO_NAME__="crypto"
export __FABCA__="${__MOUNT_DIR__}/fabca"
export __CRYPTO__="${__MOUNT_DIR__}/${__CRYPTO_NAME__}"
export __CRYPTO_PEER__="${__CRYPTO__}/peerOrganizations"
export __CRYPTO_ORDERER__="${__CRYPTO__}/ordererOrganizations"
export __CFG__="${_BIN}/cfg"

# tlsca удостоверяющий сервер
export __TLSCA_SRV_HOME__="${__FABCA__}/tlsca-server"
export __TLSCA_ADM_HOME__="${__FABCA__}/tlsca-admin"
export __TLSCA_SCR__="0.0.0.0:${__TLSCA_PORT__}"
export __TLSCA_LOG__="${__LOGS_DIR__}/ca-server-tls.txt"

# ca(msp) удостоверяющий сервер
export __CA_SRV_HOME__="${__FABCA__}/ca-server"
export __CA_ADM_HOME__="${__FABCA__}/ca-admin"
export __CA_SCR__="0.0.0.0:${__CA_PORT__}"
export __CA_LOG__="${__LOGS_DIR__}/ca-server-msp.txt"

# Защита подключения к удостоверяющим центрам
export __CONN_TLS__="${__FABCA__}/tls"
export __CONN_CA_CERT__="${__CONN_TLS__}/ca-cert.pem"
export __CONN_SRV_KEY__="${__CONN_TLS__}/server-key.pem"
export __CONN_SRV_CERT__="${__CONN_TLS__}/server-cert.pem"

# mutual authentication
export __CONN_ADM_KEY__="${__CONN_TLS__}/admin-key.pem"
export __CONN_ADM_CERT__="${__CONN_TLS__}/admin-cert.pem"

# enroll - reenroll
export __REENROLL__=

# --------------------------
# FABRIC CLIENT
# info, warning, debug, error, fatal, critical
export FABRIC_CA_CLIENT_LOGLEVEL="warning"
export FABRIC_CA_CLIENT_DEBUG=false
export FABRIC_CA_CLIENT_TLS_CLIENT_CERTFILE="$__CONN_ADM_CERT__"
export FABRIC_CA_CLIENT_TLS_CLIENT_KEYFILE="$__CONN_ADM_KEY__"
export FABRIC_CA_CLIENT_TLS_CERTFILES="$__CONN_CA_CERT__"

export FABRIC_CA_CLIENT_BCCSP_PKCS11_LIBRARY="$__HSM_LIB__"
export FABRIC_CA_CLIENT_BCCSP_PKCS11_PIN="$__HSM_PIN__"
export FABRIC_CA_CLIENT_BCCSP_PKCS11_LABEL="$__HSM_SLOT__"
export FABRIC_CA_CLIENT_BCCSP_PKCS11_HASH=SHA2
export FABRIC_CA_CLIENT_BCCSP_PKCS11_SECURITY=256

# FABRIC SERVER
# info, warning, debug, error, fatal, critical
export FABRIC_CA_SERVER_LOGLEVEL="warning"
export FABRIC_CA_SERVER_BCCSP_PKCS11_LIBRARY="$__HSM_LIB__"
export FABRIC_CA_SERVER_BCCSP_PKCS11_PIN="$__HSM_PIN__"
export FABRIC_CA_SERVER_BCCSP_PKCS11_LABEL="$__HSM_SLOT__"
export FABRIC_CA_SERVER_BCCSP_PKCS11_HASH=SHA2
export FABRIC_CA_SERVER_BCCSP_PKCS11_SECURITY=256
export FABRIC_CA_SERVER_BCCSP_PKCS11_FILEKEYSTORE_KEYSTORE=msp/keystore

# --------------------------
fabric-ca-client () {
  local cmd=$1
  shift
  if [[ "$cmd" == "enroll" ]]; then
    [ "$REENROLL" ] && cmd=reenroll
  fi

  "${_BIN}/bin.1.4.9/fabric-ca-client" "$cmd" "$@"

  return 0
}

export -f fabric-ca-client

# --------------------------

dir-empty() {
  local dir=$1
[ -d "$dir" ] && [ "$(ls "$dir")" ] &&
  echo "Директория [$dir] не пуста" &&
  return 1

  return 0
}

export -f dir-empty

# --------------------------
export __SOFTHSM_TOKENS__="${__FABCA__}/softhsm/tokens"
export __ERR_DENY_PROD__="ERROR: Запрещено в PROD режиме"
export __DOCKER_CONTAINER_NAME__="${DOCKER_CONTAINER_NAME:?}"
