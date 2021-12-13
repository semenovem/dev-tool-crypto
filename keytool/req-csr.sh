#!/bin/bash

echo "#################################################################"
echo "# Создать запрос на выпуск сертификата                          #"
echo "#################################################################"

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN:?}/util.sh"

[ -f "$__REQ_CERT__" ] && echo "Файл '$__REQ_CERT__' уже существует" && exit 1

keytool -certreq -keystore "$__STORE__" -storepass "$__PIN__" \
    -alias "$__ALIAS_KEY__" \
    -file "$__REQ_CERT__"

[ $? -ne 0 ] && exit 1

echo "Файл запроса на выпуск сертификата: $__REQ_CERT__"
