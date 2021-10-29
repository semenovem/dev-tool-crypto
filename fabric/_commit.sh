#!/bin/bash

docker exec -it fabric-ca bash -c "./inside/clean.sh && ./inside/dev.sh && ./enroll.sh"

rm -rf  /Users/sem/_dev/_work/afsc-v2-copy/testbeds/dev/crypto-config/*

bash copy-crypto.sh "/Users/sem/_dev/_work/afsc-v2-copy/testbeds/dev/crypto-config"
