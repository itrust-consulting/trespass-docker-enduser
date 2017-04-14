#!/bin/bash

MEM_REV=$(sha256sum /usr/local/share/ca-certificates/sc-chain.crt 2>/dev/null | awk '{print $1}')

openssl s_client -showcerts -connect sc:443 </dev/null 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /tmp/certs

CURRENT_REV=$(sha256sum /tmp/certs 2>/dev/null | awk '{print $1}')

if [[ "$MEM_REV" != "$CURRENT_REV" ]]; then
        cp /tmp/certs /usr/local/share/ca-certificates/sc-chain.crt
        update-ca-certificates
fi

keytool -import -noprompt -trustcacerts -alias sc -file /tmp/certs -keystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts -storepass changeit
