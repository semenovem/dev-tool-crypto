#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")

export ORG="org-gpn"

bash "${BIN}/inside/clean.sh"
bash "${BIN}/start-ca.sh"
bash "${BIN}/enroll.sh"


export ORG="org-example"

bash "${BIN}/inside/clean.sh"
bash "${BIN}/start-ca.sh"
bash "${BIN}/enroll.sh"
