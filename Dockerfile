FROM node:7-alpine
MAINTAINER Rafael Willians <me@rwillians.com>

ENV LD_LIBRARY_PATH="/opt/oracle/instantclient"
ENV OCI_HOME="/opt/oracle/instantclient"
ENV OCI_LIB_DIR="/opt/oracle/instantclient"
ENV OCI_INCLUDE_DIR="/opt/oracle/instantclient/sdk/include"

RUN mkdir -p opt/oracle
WORKDIR /opt/oracle
COPY ./oracle/ ./

RUN apk add --no-cache --virtual .build-deps \
        unzip \
        musl-utils

RUN unzip instantclient-basic-linux.x64-12.2.0.1.0.zip \
    && unzip instantclient-sdk-linux.x64-12.2.0.1.0.zip \
    && rm instantclient-basic-linux.x64-12.2.0.1.0.zip instantclient-sdk-linux.x64-12.2.0.1.0.zip \
    && mv instantclient_12_2 instantclient

RUN cd instantclient \
    && ln -s libclntsh.so.12.1 libclntsh.so


RUN mkdir -p /etc/ld.so.conf.d \
    && echo '/opt/oracle/instantclient/' | tee -a /etc/ld.so.conf.d/oracle_instant_client.conf \

RUN /sbin/ldconfig

RUN apk del .build-deps
