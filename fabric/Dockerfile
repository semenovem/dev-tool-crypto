FROM ubuntu:20.04

RUN apt-get update \
  && apt-get install -y dialog apt-utils softhsm curl \
  && apt-get clean

COPY bin.1.4.9/fabric-ca-client /usr/bin/
COPY bin.1.4.9/fabric-ca-server /usr/bin/
COPY bin.1.4.9/hsmc /usr/bin/

#COPY bin.1.4.9/ /bin-fabric-ca
#RUN chmod -R +x /bin-fabric-ca

#ARG HSM_SLOT
#ARG HSM_PIN
#
#RUN softhsm2-util --init-token --slot 0 \
#        --label $HSM_SLOT \
#        --pin $HSM_PIN \
#        --so-pin 1212
