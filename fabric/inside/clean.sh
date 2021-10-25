#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

[ -z "$__PRODUCTION__" ] && echo "$__ERR_DENY_PROD__" && exit 1

bash "${BIN}/../stop-ca.sh" || exit 1
rm -rf "${__FABCA__:?}" || exit 1
rm -rf "${__CRYPTO__:?}" || exit 1

hsmc list -s "$__HSM_SLOT__" -p "$__HSM_PIN__" -lib "$__HSM_LIB__" |
  awk '{ gsub(/handle=/, ""); print $1 }' |
  xargs -I{} hsmc destroy -s "$__HSM_SLOT__" -p "$__HSM_PIN__" -lib "$__HSM_LIB__" -confirm=false {}
