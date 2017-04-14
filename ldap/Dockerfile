FROM debian:jessie

ENV OPENLDAP_VERSION 2.4.40

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        slapd=${OPENLDAP_VERSION}* ldap-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mv /etc/ldap /etc/ldap.dist

COPY modules/ /etc/ldap.dist/modules

COPY entrypoint.sh /entrypoint.sh

EXPOSE 389

COPY add_ou.ldif /add_ou.ldif

VOLUME ["/etc/ldap", "/var/lib/ldap"]

RUN chmod +x /entrypoint.sh

RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Luxembourg /etc/localtime
RUN echo "Europe/Luxembourg" > /etc/timezone

ENTRYPOINT ["/entrypoint.sh"]

CMD ["slapd", "-d", "32768", "-u", "openldap", "-g", "openldap"]
