#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../../util.sh" "../.."

export FABRIC_CA_CLIENT_URL="$__CA_URL__"
export FABRIC_CA_CLIENT_HOME="$__CA_ADM_HOME__"
export FABRIC_CA_CLIENT_BCCSP_DEFAULT="$__BCCSP_DEFAULT__"
URL="$__CA_SCR__"

MSP_DIR="${__CRYPTO_PEER__}/gpn.ru/peers/peer0.gpn.ru/msp"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://peer0.gpn.ru:peer0PW@${URL}" \
    --csr.names 'C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC),OU=GPN' \
    --mspdir "$MSP_DIR" || exit 1
)

MSP_DIR="${__CRYPTO_PEER__}/gpn.ru/peers/peer1.gpn.ru/msp"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://peer1.gpn.ru:peer1PW@${URL}" \
    --csr.names 'C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC),OU=GPN' \
    --mspdir "$MSP_DIR" || exit 1
)

MSP_DIR="${__CRYPTO_PEER__}/gpn.ru/users/Admin@gpn.ru/msp"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://Admin@gpn.ru:AdminPW@${URL}" \
    --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC)" \
    --mspdir "$MSP_DIR" || exit 1
)

MSP_DIR="${__CRYPTO_PEER__}/gpn.ru/users/User1@gpn.ru/msp"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://User1@gpn.ru:UserPW@${URL}" \
    --mspdir "$MSP_DIR" || exit 1
)

# --- gpn
MSP_DIR="${__CRYPTO_PEER__}/gpn.ru/msp"
fabric-ca-client getcainfo --enrollment.profile ca --mspdir "$MSP_DIR"

exit 0
