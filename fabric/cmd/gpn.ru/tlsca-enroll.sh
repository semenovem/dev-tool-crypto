#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../../util.sh" "../.."

export FABRIC_CA_CLIENT_HOME="$__TLSCA_ADM_HOME__"
URL="$__TLSCA_SCR__"

# ---
MSP_DIR="${__CRYPTO_PEER__}/gpn.ru/peers/peer0.gpn.ru/tls"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://peer0.gpn.ru:peer0PW@${URL}" \
    --enrollment.profile tls \
    --csr.hosts "peer0.gpn.ru" \
    --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC)" \
    --mspdir "$MSP_DIR" || exit 1
)

# ---
MSP_DIR="${__CRYPTO_PEER__}/gpn.ru/peers/peer1.gpn.ru/tls"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://peer1.gpn.ru:peer1PW@${URL}" \
    --enrollment.profile tls \
    --csr.hosts "peer1.gpn.ru" \
    --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC)" \
    --mspdir "$MSP_DIR" || exit 1
)

# ---
MSP_DIR="${__CRYPTO_PEER__}/gpn.ru/users/Admin@gpn.ru/tls"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://Admin@gpn.ru:AdminPW@${URL}" \
    --enrollment.profile tls \
    --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC)" \
    --mspdir "$MSP_DIR" || exit 1
)

# --- gpn
MSP_DIR="${__CRYPTO_PEER__}/gpn.ru/msp"
fabric-ca-client getcainfo --enrollment.profile tls --mspdir "$MSP_DIR"

exit 0
