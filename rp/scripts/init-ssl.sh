#!/bin/bash

SUBJECT="/C=EU/ST=trespass/L=trespass/O=trespass/CN=*.$DNS_VALUE"
SUBJECT_CA="/C=EU/ST=trespass/L=trespass/O=trespass/CN=ca.$DNS_VALUE"
DAYS_TO_EXPIRATION=9000

openssl req -new \
            -newkey rsa:4096 \
            -days 365 \
            -nodes \
            -x509 \
            -subj $SUBJECT \
            -keyout /keys/cert.key \
            -out /certs/cert.crt

openssl req -new \
            -newkey rsa:4096 \
            -days 365 \
            -nodes \
            -x509 \
            -subj $SUBJECT_CA \
            -keyout /keys/ca.key \
            -out /certs/ca.crt

openssl req -subj $SUBJECT -new -key /keys/cert.key -out /certs/cert.csr

openssl x509 -req -days $DAYS_TO_EXPIRATION -in /certs/cert.csr -CA /certs/ca.crt -CAkey /keys/ca.key -set_serial 001 -out /certs/cert.crt

chmod 777 /keys/cert.key /certs/ca.crt /certs/cert.crt

cat /certs/ca.crt >> /certs/cert.crt
