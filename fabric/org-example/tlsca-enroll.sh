#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN:?}/../util.sh" ".."

export FABRIC_CA_CLIENT_HOME="$__TLSCA_ADM_HOME__"
URL="$__TLSCA_SCR__"

# ---
MSP_DIR="${__CRYPTO_PEER__}/vtb.ru/peers/peer0.vtb.ru/tls"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://peer0.vtb.ru:peer0PW@${URL}" \
    --enrollment.profile tls \
    --csr.hosts "peer0.vtb.ru" \
    --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC),OU=AFSC" \
    --mspdir "$MSP_DIR" || exit 1
)

# ---
MSP_DIR="${__CRYPTO_PEER__}/vtb.ru/peers/peer1.vtb.ru/tls"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://peer1.vtb.ru:peer1PW@${URL}" \
    --enrollment.profile tls \
    --csr.hosts "peer1.vtb.ru" \
    --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC),OU=AFSC" \
    --mspdir "$MSP_DIR" || exit 1
)

# ---
MSP_DIR="${__CRYPTO_PEER__}/vtb.ru/users/Admin@vtb.ru/tls"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://Admin@vtb.ru:AdminPW@${URL}" \
    --enrollment.profile tls \
    --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC)" \
    --mspdir "$MSP_DIR" || exit 1
)

# ---
MSP_DIR="${__CRYPTO_PEER__}/vtb.ru/users/User1@vtb.ru/tls"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://User1@vtb.ru:User1PW@${URL}" \
    --enrollment.profile tls \
    --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC)" \
    --mspdir "$MSP_DIR" || exit 1
)

# --- orderer admin
MSP_DIR="${__CRYPTO_ORDERER__}/vtb.ru/users/Admin@orderer.vtb.ru/tls"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://Admin@orderer.vtb.ru:AdminPW@${URL}" \
    --enrollment.profile tls \
    --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC),OU=admin" \
    --mspdir "$MSP_DIR" || exit 1
)

# --- orderer
MSP_DIR="${__CRYPTO_ORDERER__}/vtb.ru/orderers/orderer.vtb.ru/tls"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://orderer.vtb.ru:ordererPW@${URL}" \
    --enrollment.profile tls \
    --csr.hosts "orderer.vtb.ru" \
    --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC),OU=orderer" \
    --mspdir "$MSP_DIR" || exit 1
)

# --- orderer
MSP_DIR="${__CRYPTO_ORDERER__}/vtb.ru/msp"
fabric-ca-client getcainfo --enrollment.profile tls --mspdir "$MSP_DIR"

# --- vtb
MSP_DIR="${__CRYPTO_PEER__}/vtb.ru/msp"
fabric-ca-client getcainfo --enrollment.profile tls --mspdir "$MSP_DIR"

exit 0
