#!/bin/bash -e

filename=$1

openssl genrsa -aes256 -passout pass:gsahdg -out $filename.pass.key 4096 && \
openssl rsa -passin pass:gsahdg -in $filename.pass.key -out $filename.key && \
rm $filename.pass.key && \
openssl req -new -key $filename.key -out $filename.csr && \
openssl x509 -req -sha256 -days 365 -in $filename.csr -signkey $filename.key -out $filename.crt
