#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../../util.sh" "../.."

[ -d "$__CONN_TLS__" ] && [ "$(ls "$__CONN_TLS__")" ] &&
  echo "Директория [$__CONN_TLS__] не пуста" &&
  exit 1

mkdir -p "$__CONN_TLS__" || exit 1

CA_KEY="${__CONN_TLS__}/ca-key.pem"
SRV_CSR="${__CONN_TLS__}/srv-csr.pem"
SRV_SSL_CONF="${BIN}/tls-srv.conf"

ADM_CSR="${__CONN_TLS__}/adm-csr.pem"
ADM_SSL_CONF="${BIN}/tls-adm.conf"

openssl req -x509 -newkey rsa:4096 -days 3650 -nodes \
  -keyout "$CA_KEY" \
  -out "$__CONN_CA_CERT__" \
  -subj "/C=RU/ST=MO/L=Moscow/O=VTB/OU=Finance/CN='bhive_inet_hldg_20x'/emailAddress=emsemenov@vtb.ru"

[ $? -ne 0 ] && exit 1

# Генерация ключа сервера
openssl req -new -newkey rsa:2048 -nodes \
  -keyout "$__CONN_SRV_KEY__" \
  -out "$SRV_CSR" \
  -config "$SRV_SSL_CONF"

[ "$?" -ne "0" ] && exit 1

# подпись удостоверяющим центром
openssl x509 -req -days "365" \
  -in "$SRV_CSR" \
  -extfile "$SRV_SSL_CONF" \
  -extensions req_ext \
  -CA "$__CONN_CA_CERT__" \
  -CAkey "$CA_KEY" \
  -CAcreateserial \
  -out "$__CONN_SRV_CERT__"

[ "$?" -ne "0" ] && exit 1

# Генерация ключа админа
openssl req -new -newkey rsa:2048 -nodes \
  -keyout "$__CONN_ADM_KEY__" \
  -out "$ADM_CSR" \
  -config "$ADM_SSL_CONF"

[ "$?" -ne "0" ] && exit 1

# подпись удостоверяющим центром
openssl x509 -req -days "365" \
  -in "$ADM_CSR" \
  -extfile "$ADM_SSL_CONF" \
  -extensions req_ext \
  -CA "$__CONN_CA_CERT__" \
  -CAkey "$CA_KEY" \
  -CAcreateserial \
  -out "$__CONN_ADM_CERT__"
