FROM alpine:edge

LABEL maintainer="Ramon van Stijn <ramons@nl.ibm.com"

ARG version=2.8.3

RUN addgroup -g 1970 ansible \
    && adduser -u 1970 -G ansible -s /bin/sh -D ansible

RUN apk upgrade --no-cache \
    && apk add --no-cache \
        python3 \
        openssh-client \
        sshpass

RUN apk add --no-cache --virtual build-deps \
    gcc \
    python3-dev \
    musl-dev \
    libffi-dev \
    openssl-dev \
    && pip3 install --no-cache-dir ansible==${version} \
    && apk del build-deps

WORKDIR /playbook

USER ansible

ENTRYPOINT ["ansible-playbook"]
