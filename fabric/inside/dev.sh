#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN:?}/../util.sh" ".."

bash "${BIN}/mkslot.sh" || exit 1
bash "${BIN}/../start-ca.sh"
