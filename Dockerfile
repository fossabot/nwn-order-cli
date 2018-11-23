FROM jakkn/nwnsc as nwnsc

FROM nimlang/nim:latest as nim
RUN apt-get update \
    && apt-get -qy install curl libssl-dev build-essential gcc git \
    && git clone --recursive https://github.com/niv/neverwinter_utils.nim \
    && cd neverwinter_utils.nim \
    && nimble build -d:release \
    && mv bin/* /usr/local/bin/

FROM golang:1.11.0 as go
ADD . /order-cli
WORKDIR /order-cli
RUN apt update \
    && go mod download\
    && apt-get -y install git gcc \
    && apt-get upgrade -y \
    && rm -r /var/lib/apt/lists /var/cache/apt \
    && go build -o ./bin/order-cli

FROM ubuntu:latest
LABEL maintainer "urothis@gmail.com"
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get clean
# copy nwnsc 
COPY --from=nwnsc /usr/local/bin/nwnsc /usr/local/bin/
COPY --from=nwnsc /nwn .
COPY --from=go /order-cli/bin /order-cli/
ENV NWN_INSTALLDIR=/nwn/data

# copy nim image
COPY --from=nim /usr/local/bin/* /usr/local/bin/

# run order-cli
ENTRYPOINT ./order-cli
WORKDIR /order-cli