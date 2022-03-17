#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

export FABRIC_CA_CLIENT_URL="$__CA_URL__"
export FABRIC_CA_CLIENT_HOME="$__CA_ADM_HOME__"
export FABRIC_CA_CLIENT_BCCSP_DEFAULT="$__BCCSP_DEFAULT__"
URL="$__CA_SCR__"
SUBJ="C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC)"

MSP_DIR="${__CRYPTO_PEER__}/vtb.ru/peers/peer0.vtb.ru/msp"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://peer0.vtb.ru:peer0PW@${URL}" \
    --csr.names "$SUBJ" \
    --mspdir "$MSP_DIR" || exit 1
)

MSP_DIR="${__CRYPTO_PEER__}/vtb.ru/peers/peer1.vtb.ru/msp"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://peer1.vtb.ru:peer1PW@${URL}" \
    --csr.names "$SUBJ" \
    --mspdir "$MSP_DIR" || exit 1
)

MSP_DIR="${__CRYPTO_PEER__}/vtb.ru/users/Admin@vtb.ru/msp"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://Admin@vtb.ru:AdminPW@${URL}" \
    --csr.names "$SUBJ" \
    --mspdir "$MSP_DIR" || exit 1
)

MSP_DIR="${__CRYPTO_PEER__}/vtb.ru/users/User1@vtb.ru/msp"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://User1@vtb.ru:UserPW@${URL}" \
    --csr.names "$SUBJ" \
    --mspdir "$MSP_DIR" || exit 1
)

# --- orderer admin
MSP_DIR="${__CRYPTO_ORDERER__}/vtb.ru/users/Admin@orderer.vtb.ru/msp"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://Admin@orderer.vtb.ru:AdminPW@${URL}" \
    --csr.names "$SUBJ" \
    --mspdir "$MSP_DIR" || exit 1
)

# --- orderer
MSP_DIR="${__CRYPTO_ORDERER__}/vtb.ru/orderers/orderer.vtb.ru/msp"
dir-empty "$MSP_DIR" && (
  fabric-ca-client enroll -u "https://orderer.vtb.ru:ordererPW@${URL}" \
    --csr.names "$SUBJ" \
    --mspdir "$MSP_DIR" || exit 1
)

# --- orderer
MSP_DIR="${__CRYPTO_ORDERER__}/vtb.ru/msp"
fabric-ca-client getcainfo --enrollment.profile ca --mspdir "$MSP_DIR"

# --- vtb
MSP_DIR="${__CRYPTO_PEER__}/vtb.ru/msp"
fabric-ca-client getcainfo --enrollment.profile ca --mspdir "$MSP_DIR"
