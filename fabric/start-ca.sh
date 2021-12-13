#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN:?}/util.sh" ""

# Проверить tls серты
if [ ! -d "$__CONN_TLS__" ] || [ -z "$(ls "$__CONN_TLS__")" ]; then
  bash "${__PROJ__}/conn-tls/gen.sh"
fi

# Если задан softhsm, создать файл конфигурации

bash "${__PROJ__}/tlsca-server.sh" || exit 1
bash "${__PROJ__}/ca-server.sh" || exit 1
