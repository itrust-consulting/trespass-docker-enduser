#!/bin/bash

#DNS_VALUE=${DNS_VALUE:-trespass.eu}

while [ ! -f /certs/cert.crt ]
do
  sleep 2
done

cp /certs/cert.crt /usr/local/share/ca-certificates/cert-chain.crt
update-ca-certificates

keytool -delete -noprompt -trustcacerts -alias "cas.$DNS_VALUE" -keystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts -storepass changeit 2>/dev/null
keytool -import -noprompt -trustcacerts -alias "cas.$DNS_VALUE" -file /certs/cert.crt -keystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts -storepass changeit
