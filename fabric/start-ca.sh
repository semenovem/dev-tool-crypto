#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/util.sh" ""

# Проверить tls серты
if [ ! -d "$__CONN_TLS__" ] || [ -z "$(ls "$__CONN_TLS__")" ]; then
  bash "${BIN}/conn-tls/conn-gen.sh"
 fi

bash "${BIN}/cmd/tlsca-server.sh" || exit 1
bash "${BIN}/cmd/ca-server.sh" || exit 1
