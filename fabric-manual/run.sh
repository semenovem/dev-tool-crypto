#!/bin/bash

# контейнер для разработки
# docker run -it --rm -w /app -v $PWD:/app ubuntu:20.04 bash
#

_MSP_="VTBMSP"

# Admin peer
_MEMBER_="afsc-adm@vtb.ru"
bash make_req.sh "./requests/req/msp-${_MEMBER_}" "msp-${_MEMBER_}" "admin" "$_MSP_"
TLS=1 bash make_req.sh "./requests/tls-req/tls-${_MEMBER_}" "tls-${_MEMBER_}" "admin" "$_MSP_"

# user for afsc
_MEMBER_="afsc-user@vtb.ru"
bash make_req.sh "./requests/req/msp-${_MEMBER_}" "msp-${_MEMBER_}" "client" "$_MSP_"
TLS=1 bash make_req.sh "./requests/tls-req/tls-${_MEMBER_}" "tls-${_MEMBER_}" "client" "$_MSP_"

# peer afsc-peer0
_MEMBER_="afsc-peer0.vtb.ru"
bash make_req.sh "./requests/req/msp-${_MEMBER_}" "msp-${_MEMBER_}" "peer" "$_MSP_"
TLS=1 bash make_req.sh "./requests/tls-req/tls-${_MEMBER_}" "tls-${_MEMBER_}" "peer" "$_MSP_"

# peer afsc-peer1
_MEMBER_="afsc-peer1.vtb.ru"
bash make_req.sh "./requests/req/msp-${_MEMBER_}" "msp-${_MEMBER_}" "peer" "$_MSP_"
TLS=1 bash make_req.sh "./requests/tls-req/tls-${_MEMBER_}" "tls-${_MEMBER_}" "peer" "$_MSP_"
