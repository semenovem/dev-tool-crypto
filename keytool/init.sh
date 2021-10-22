#!/bin/bash

echo "#################################################################"
echo "# Создает хранилище и закрытый ключ                             #"
echo "#################################################################"

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/util.sh"

[ -f "$__STORE__" ] && echo "Файл '$__STORE__' уже существует" && exit 1
[ ! -d "$__STORE_NAME__" ] && (mkdir "$__STORE_NAME__" || exit 1)

keytool -genkey -keystore "$__STORE__" -storepass "$__PIN__" \
    -alias "$__ALIAS_KEY__" \
    -keyalg RSA \
    -dname "$__DNAME__" \
    -keysize 2048 \
    -keypass "$__PIN__"

[ $? -ne 0 ] && exit 1

echo \
"JKS.keystore = укажи путь к файлу хранилищу без расширения: например store/keystore
JKS.certificate = ${__ALIAS_KEY__}
JKS.encrypted = no
JKS.keystore_pass = ${__PIN__}
JKS.key_pass = ${__PIN__}
JKS.provider = IBMJCE
" > "${__CONF__}"
