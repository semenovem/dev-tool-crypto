#!/bin/bash

HSM_LIB="1"
HSM_SLOT="1"
HSM_PIN="1"

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/util.sh" ""

DEST="crypto"

[ -z "$DEST" ] &&
  echo "Не указана директория, куда скопировать крипто-материалы" &&
  exit 1

[[ "$DEST" != /* ]] && DEST="${BIN}/${DEST}"

[ -d "$DEST" ] && [ "$(ls "$DEST")" ] && echo "Директория [$DEST] не пуста" && exit 1

if [ ! -d "$DEST" ]; then
  [ ! -d "$(dirname "$DEST")" ] &&
    echo "Указанная директория не имеет родительской директории" &&
    exit 1

  mkdir -p "$DEST" || exit 1
fi

LOCAL=
ID=$(docker container ls -f name="^${__DOCKER_CONTAINER_NAME__}\$" -q) || exit 1
if [ -z "$ID" ]; then
  echo "Контейнер не запущен, пробуем запустить"

  make DETACH="-d" CMD="bash" dev
  LOCAL=true

  sleep 1
fi

docker cp "${__DOCKER_CONTAINER_NAME__}:${__CRYPTO__}/." "$DEST"

[ "$LOCAL" ] && (docker stop "$__DOCKER_CONTAINER_NAME__" || exit 1)
