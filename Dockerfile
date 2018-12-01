FROM jakkn/nwnsc as nwnsc
FROM nimlang/nim:latest as nim
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get -qy install curl libssl-dev build-essential gcc git \
    && git clone --recursive https://github.com/niv/neverwinter_utils.nim \
    && cd neverwinter_utils.nim \
    && nimble build -d:release \
    && mv bin/* /usr/local/bin/
FROM golang:1.11.0 as nwn-order-cli-builder
RUN apt update \
    && apt upgrade -y \
    && git clone https://github.com/Urothis/nwn-order-cli.git \
    && cd nwn-order-cli \
    && go mod download \
    && go build -o ./bin/order-cli \
    && mv bin/* /usr/local/bin/
FROM ubuntu:latest
LABEL maintainer "urothis@gmail.com"
# copy nwnsc 
COPY --from=nwnsc /usr/local/bin/nwnsc /usr/local/bin/
COPY --from=nwnsc /nwn .
ENV NWN_INSTALLDIR=/nwn/data
# copy go
COPY --from=nwn-order-cli-builder /usr/local/bin/ /usr/local/bin/
# copy nim image
COPY --from=nim /usr/local/bin/* /usr/local/bin/
RUN apt-get update \
    && apt-get upgrade -y \
    && chmod +x ./usr/local/bin/order-cli
# run order-cli
ENTRYPOINT [ "order-cli" ]