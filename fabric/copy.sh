#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")

TM=$(mktemp -d)

for it in org-example org-gpn ; do
  d="${TM}/${it}"
  mkdir -p "$d"

  export ORG="$it"

  bash "${BIN:?}/copy-crypto.sh" "$d"
done


mv ${TM}/org-gpn/peerOrganizations/* "${TM}/org-example/peerOrganizations/"

ls -l "${TM}/org-example/peerOrganizations"

mv  "${TM}/org-example"  /Users/sem/_dev/_work/afsc-v2/testbeds/dev/assets/crypto-config
