#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/util.sh" ""

#export FABRIC_CA_CLIENT_HOME="$__CA_ADM_HOME__"
#export FABRIC_CA_CLIENT_BCCSP_DEFAULT=PKCS11

export FABRIC_CA_CLIENT_HOME="$__TLSCA_ADM_HOME__"


fabric-ca-client certificate list
