#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

export FABRIC_CA_CLIENT_HOME="$__TLSCA_ADM_HOME__"

fabric-ca-client register --id.name peer0.vtb.ru --id.secret peer0PW \
  --id.type peer  --enrollment.profile tls  || exit 1

fabric-ca-client register --id.name peer1.vtb.ru --id.secret peer1PW \
  --id.type peer || exit 1

fabric-ca-client register --id.name Admin@vtb.ru --id.secret AdminPW \
  --id.type admin || exit 1

fabric-ca-client register --id.name User1@vtb.ru --id.secret User1PW \
  --id.type user || exit 1

# orderer
fabric-ca-client register --id.name orderer.vtb.ru --id.secret ordererPW \
  --id.type orderer || exit 1

# orderer admin
fabric-ca-client register --id.name Admin@orderer.vtb.ru --id.secret AdminPW \
  --id.type admin
