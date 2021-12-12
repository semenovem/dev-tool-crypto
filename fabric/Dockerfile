FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y dialog apt-utils softhsm curl mc \
  && apt-get clean

COPY bin.1.4.9/fabric-ca-client /usr/bin/
COPY bin.1.4.9/fabric-ca-server /usr/bin/
COPY bin.1.4.9/hsmc /usr/bin/
