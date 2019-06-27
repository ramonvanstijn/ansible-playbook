FROM alpine:edge

LABEL maintainer="Ramon van Stijn <ramons@nl.ibm.com"

RUN addgroup -g 1970 ansible \
    && adduser -u 1970 -G ansible -s /bin/sh -D ansible

RUN apk upgrade --no-cache \
    && apk add --update --no-cache \
        ansible=2.8.1-r0 \
        openssh-client \
        sshpass

WORKDIR /playbook

USER ansible

ENTRYPOINT ["ansible-playbook"]
