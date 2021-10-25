#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

export FABRIC_CA_CLIENT_HOME="$__CA_ADM_HOME__"
export FABRIC_CA_CLIENT_BCCSP_DEFAULT=PKCS11

MSP_DIR="${__CRYPTO_PEER__}/vtb.ru/peers/peer0.vtb.ru/msp"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://afsc-peer0.vtb.ru:peer0PW@${__CA_SCR__}" \
    --csr.hosts 'afsc-peer0.vtb.ru' \
    --csr.names 'C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC),OU=AFSC' \
    --mspdir "$MSP_DIR" || exit 1
)

MSP_DIR="${__CRYPTO_PEER__}/vtb.ru/peers/peer1.vtb.ru/msp"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://afsc-peer1.vtb.ru:peer1PW@${__CA_SCR__}" \
    --csr.hosts 'afsc-peer1.vtb.ru' \
    --csr.names 'C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC),OU=AFSC' \
    --mspdir "$MSP_DIR" || exit 1
)

MSP_DIR="${__CRYPTO_PEER__}/vtb.ru/users/Admin@vtb.ru/msp"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://Admin@vtb.ru:AdminPW@${__CA_SCR__}" \
    --csr.hosts afsc-peer0.vtb.ru \
    --csr.hosts afsc-peer1.vtb.ru \
    --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC)" \
    --mspdir "$MSP_DIR" || exit 1
)

MSP_DIR="${__CRYPTO_PEER__}/vtb.ru/users/User1@vtb.ru/msp"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://User1@vtb.ru:UserPW@${__CA_SCR__}" \
    --mspdir "$MSP_DIR" || exit 1
)

exit 0
