#!/bin/bash

echo "#################################################################"
echo "# Показать содержимое сущности                                  #"
echo "#################################################################"

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN:?}/util.sh"

ALIAS=$1

[ -z "$ALIAS" ] && echo "Не передан alias: ./script alias" && exit 1

TMP=$(mktemp) || exit 1

keytool -exportcert -rfc -keystore "$__STORE__" -storepass "$__PIN__" \
    -alias "$ALIAS" -file "$TMP" || exit 1

openssl x509 -noout -text -in "$TMP"
