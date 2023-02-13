ARG build_for=linux/amd64,linux/arm64
FROM ubuntu:22.04 as base

RUN apt update; apt install dnsutils -y; apt clean

RUN mkdir /app
COPY dnsloadgen.sh /app/dnsloadgen.sh

WORKDIR /app

ENTRYPOINT ["./dnsloadgen.sh"]