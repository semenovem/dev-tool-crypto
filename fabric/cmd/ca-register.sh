#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

export FABRIC_CA_CLIENT_HOME="$__CA_ADM_HOME__"
export FABRIC_CA_CLIENT_BCCSP_DEFAULT="$__BCCSP_DEFAULT__"

fabric-ca-client register --id.name afsc-peer0.vtb.ru --id.secret peer0PW \
  --id.type peer || exit 1

fabric-ca-client register --id.name afsc-peer1.vtb.ru --id.secret peer1PW \
  --id.type peer || exit 1

fabric-ca-client register --id.name Admin@vtb.ru --id.secret AdminPW \
  --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" \
  --id.type client || exit 1

fabric-ca-client register --id.name User1@vtb.ru --id.secret UserPW \
  --id.type user || exit 1

exit 0
