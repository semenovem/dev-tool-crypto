FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive.
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y language-pack-ru openssl
ENV LANGUAGE ru_RU.UTF-8
ENV LANG ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8
RUN locale-gen ru_RU.UTF-8 && dpkg-reconfigure locales
ENTRYPOINT /bin/bash
