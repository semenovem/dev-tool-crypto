#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN:?}/util.sh" ""

[ -z "$__PRODUCTION__" ] && echo "$__ERR_DENY_PROD__" && exit 1

hsmc destroy -s "$__HSM_SLOT__" -p "$__HSM_PIN__" -lib "$__HSM_LIB__" -confirm=false $@
