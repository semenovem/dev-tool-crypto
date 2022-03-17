#!/bin/bash

function makeCert() {
  local path cn ou

  path=$1
  cn=$2
  ou1=$3
  ou2=$4

  ou="0.OU=$ou1"
  if [ -n "$ou2" ]; then
    ou="$ou
1.OU=$ou2"
  fi

  mkdir -p "$(dirname $path)"

  if [[ "$TLS" == "1" ]]; then
    req="
[req_ext]
basicConstraints=critical,CA:FALSE
keyUsage=nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage=serverAuth, clientAuth, codeSigning
subjectAltName = @alt_names

[alt_names]
DNS.1 = afcs-peer0.vtb.ru
DNS.2 = afcs-peer1.vtb.ru
"
  else
    req="
[req_ext]
basicConstraints=critical,CA:FALSE
keyUsage=nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage=codeSigning
"
  fi

  openssl req -new -newkey ec -pkeyopt ec_paramgen_curve:secp384r1 \
    -pkeyopt ec_param_enc:named_curve \
    -nodes -new -sha384 \
    -out "${path}.csr" \
    -keyout "${path}.key" \
    -config <(
      cat <<-EOF
[req]
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[dn]
C=RU
ST=St. Petersburg
L=SPB
O=VTB Bank(PJSC)
$ou
CN=$cn

$req
EOF
    )
}

makeCert $*
