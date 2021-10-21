#!/bin/bash

_BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
[ "$1" ] && _BIN="${_BIN}/$1"

set -o allexport
source "${_BIN}/project.properties"
set +o allexport

export __MOUNT_DIR__="$MOUNT_DIR"

export PATH="${_BIN}/bin.1.4.9:/bin-fabric-ca:${PATH}"

export __CRYPTO_NAME__="crypto"

export __FABCA__="${__MOUNT_DIR__}/fabca"
export __CRYPTO__="${__MOUNT_DIR__}/${__CRYPTO_NAME__}"

export __CRYPTO_PEER__="${__CRYPTO__}/peerOrganizations"
export __CRYPTO_ORDERER__="${__CRYPTO__}/ordererOrganizations"

export __CFG__="${_BIN}/cfg"

export __TLSCA_PORT__="7051"
export __CA_PORT__="7053"

export __TLSCA_SRV_HOME__="${__FABCA__}/tlsca-server"
export __TLSCA_ADM_HOME__="${__FABCA__}/tlsca-admin"

export __CA_SRV_HOME__="${__FABCA__}/ca-server"
export __CA_ADM_HOME__="${__FABCA__}/ca-admin"

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

export __SOFTHSM_TOKENS__="${__FABCA__}/softhsm/tokens"

# Файл устанавливаемых свойств
FILE_PROP="${__FABCA__}/project.properties"

if [ -f "$FILE_PROP" ]; then
  set -o allexport
  source "$FILE_PROP"
  set +o allexport
fi

export __TLSCA_SCR__="0.0.0.0:${__TLSCA_PORT__}"
export __CA_SCR__="0.0.0.0:${__CA_PORT__}"


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