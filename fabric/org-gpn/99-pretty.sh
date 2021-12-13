#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN:?}/../util.sh" ".."

TLSCA_CERT="${__TLSCA_SRV_HOME__}/tlsca-cert.pem"

for f in $(find "${__CRYPTO__:?}" -iname "*_sk"); do
  # в директории обычно есть только 1 key файл
  L="$(find "$(dirname "$f")" -type f | wc -l)"
  [ "$L" -ne 1 ] && echo -e "В Директории $(dirname "$f") содержится более 1 файла ls: \n $(ls -l "$(dirname "$f")")"

  mv "$f" "$(dirname "$f")/key.pem" || exit 1
done

for f in $(find "${__CRYPTO__:?}" -iname "0-0-0-0-${__CA_PORT__}.pem"); do
  mv "$f" "$(dirname "$f")/cacert.pem" || exit 1
done

for f in $(find "${__CRYPTO__:?}" -iname "tls-0-0-0-0-${__TLSCA_PORT__}.pem"); do
  mv "$f" "$(dirname "$f")/tlsca-cert.pem" || exit 1
done

for DIR in $(find "${__CRYPTO__:?}" -depth -type d); do
  [ -z "$DIR" ] && continue

  TMP_DIR=$(mktemp -d) || exit 1
  [ -z "$TMP_DIR" ] && exit 1

  # TLS
  if [[ $DIR == *"/tls" ]]; then
    [ -f "${DIR}/keystore/key.pem" ] &&
      (mv "${DIR}/keystore/key.pem" "$TMP_DIR" || exit 1)

    [ -f "${DIR}/signcerts/cert.pem" ] &&
      (mv "${DIR}/signcerts/cert.pem" "$TMP_DIR" || exit 1)

    [ -f "${DIR}/tlscacerts/tlsca-cert.pem" ] &&
      (mv "${DIR}/tlscacerts/tlsca-cert.pem" "${TMP_DIR}/ca.pem" || exit 1)

    rm -rf "$DIR" || exit 1
    mv "$TMP_DIR" "$DIR" || exit 1
  fi

  # MSP
  if [[ $DIR == *"/msp" ]]; then
    [ ! -f "${DIR}/config.yaml" ] && (cp "${BIN}/config.yaml" "$DIR" || exit 1)

    mkdir -p "${DIR}/tlscacerts" || exit 1

    [ ! -f "${DIR}/tlscacerts/tlsca-cert.pem" ] &&
      (cp "$TLSCA_CERT" "${DIR}/tlscacerts/tlsca-cert.pem" || exit 1)
  fi
done

# peer gpn.ru
ADMIN_CERT="${__CRYPTO_PEER__}/gpn.ru/users/Admin@gpn.ru/msp/signcerts/cert.pem"
for DIR in $(find "${__CRYPTO_PEER__:?}/gpn.ru/peers" -depth -type d); do
  [ -z "$DIR" ] && continue
  [[ ! $DIR == *"/msp" ]] && continue
  TARGET="${DIR}/admincerts"
  mkdir -p "$TARGET" || exit 1
  [ ! -f "${TARGET}/cert.pem" ] && (cp "$ADMIN_CERT" "$TARGET" || exit 1)
done
