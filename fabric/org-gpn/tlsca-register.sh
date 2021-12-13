#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN:?}/../util.sh" ".."

export FABRIC_CA_CLIENT_HOME="$__TLSCA_ADM_HOME__"

fabric-ca-client register --id.name peer0.gpn.ru --id.secret peer0PW || exit 1

fabric-ca-client register --id.name peer1.gpn.ru --id.secret peer1PW || exit 1

fabric-ca-client register --id.name Admin@gpn.ru --id.secret AdminPW || exit 1

fabric-ca-client register --id.name User1@gpn.ru --id.secret User1PW || exit 1

exit 0
