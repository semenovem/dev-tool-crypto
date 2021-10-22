#!/bin/bash

echo "#################################################################"
echo "# Извлечь сущность в формате .pem                               #"
echo "#################################################################"

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/util.sh"

ALIAS=$1
FILE=$2

[ -z "$ALIAS" ] && echo "Не передан alias сущности: ./script alias" && exit 1
[ "$FILE" ] && [ -f "$FILE" ] && echo "Файл ужу существует" && exit 1

PEM=$(keytool -list -rfc -keystore "$_STORE_" -storepass "$_PASS_" \
    -alias "$ALIAS")

echo "$PEM"

[ "$FILE" ] && echo "$PEM" > "$FILE"
