#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

export FABRIC_CA_CLIENT_HOME="$__TLSCA_ADM_HOME__"

fabric-ca-client enroll -u "https://afsc-peer0.vtb.ru:peer0PW@${__TLSCA_SCR__}" \
  --enrollment.profile tls \
  --csr.hosts afsc-peer0.vtb.ru \
  --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC),OU=AFSC" \
  --mspdir "${__CRYPTO_PEER__}/vtb.ru/peers/peer0.vtb.ru/tls"

[ $? -ne 0 ] && exit 1


fabric-ca-client enroll -u "https://afsc-peer1.vtb.ru:peer1PW@${__TLSCA_SCR__}" \
  --enrollment.profile tls \
  --csr.hosts afsc-peer1.vtb.ru \
  --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC),OU=AFSC" \
  --mspdir "${__CRYPTO_PEER__}/vtb.ru/peers/peer1.vtb.ru/tls"

[ $? -ne 0 ] && exit 1

fabric-ca-client enroll -u "https://Admin@vtb.ru:AdminPW@${__TLSCA_SCR__}" \
  --enrollment.profile tls \
  --csr.hosts afsc-peer0.vtb.ru \
  --csr.hosts afsc-peer1.vtb.ru \
  --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC)" \
  --mspdir "${__CRYPTO_PEER__}/vtb.ru/users/Admin@vtb.ru/tls"

[ $? -ne 0 ] && exit 1

fabric-ca-client enroll -u "https://User1@vtb.ru:User1PW@${__TLSCA_SCR__}" \
  --enrollment.profile tls \
  --csr.hosts afsc-peer0.vtb.ru \
  --csr.hosts afsc-peer1.vtb.ru \
  --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC)" \
  --mspdir "${__CRYPTO_PEER__}/vtb.ru/users/User1@vtb.ru/tls"

exit $?
