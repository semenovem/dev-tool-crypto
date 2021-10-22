#!/bin/bash

echo "#################################################################"
echo "# Удалить сущность из хранилища                                 #"
echo "#################################################################"

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/util.sh"

ALIAS=$1

[ -z "$ALIAS" ] && echo "Не передан alias сущности: ./script alias" && exit 1
[ "$ALIAS" = "$__ALIAS_KEY__" ] && echo "Нельзя удалять приватный ключ" && exit 1

keytool -delete -keystore "$__STORE__" -storepass "$__PIN__" \
    -alias "$ALIAS"
