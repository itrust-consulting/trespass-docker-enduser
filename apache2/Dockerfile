FROM debian:jessie

ENV APACHE_RUN_USER  www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE  /var/run/apache2.pid
ENV APACHE_RUN_DIR   /var/run/apache2
ENV APACHE_LOCK_DIR  /var/lock/apache2
ENV APACHE_LOG_DIR   /var/log/apache2
ENV APACHE_USER_UID 0

# PHP && Apache
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yqq install --no-install-recommends\
    openssl \
    apache2-mpm-prefork\
    apache2-utils \
    libcurl3  libpcre3 apache2 apache2-dev dh-autoreconf libaprutil1 libaprutil1-dev libssl-dev git libcurl4-openssl-dev libpcre3-dev libapache2-svn \
    ca-certificates subversion &&\
    rm -rf /var/lib/apt/lists/* &&\
    a2enmod rewrite ssl headers proxy proxy_ajp proxy_balancer proxy_connect proxy_express proxy_fcgi proxy_fdpass proxy_ftp proxy_html proxy_http proxy_scgi proxy_wstunnel authnz_ldap xml2enc substitute &&\
    echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN openssl req \
    -new \
    -newkey rsa:4096 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=LU/ST=service/L=service/O=service/CN=localhost" \
    -keyout /epl-server.key \
    -out /epl-server.crt

RUN openssl req \
    -new \
    -newkey rsa:4096 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=LU/ST=service/L=service/O=service/CN=apache2-ca" \
    -keyout /epl-server-ca.key \
    -out /epl-server-ca.crt

RUN openssl req -subj "/C=LU/ST=service/L=service/O=service/CN=localhost" -new -key /epl-server.key -out /epl-server.csr

RUN openssl x509 -req -days 9000 -in /epl-server.csr -CA /epl-server-ca.crt -CAkey /epl-server-ca.key -set_serial 001 -out /epl-server.crt
RUN chmod 777 /epl-server.key /epl-server-ca.crt /epl-server.crt

RUN rm /etc/apache2/sites-enabled/*

RUN rm -R /var/www/*

RUN cat /epl-server-ca.crt >> /epl-server.crt

WORKDIR /opt

RUN git clone https://github.com/Jasig/mod_auth_cas.git

WORKDIR /opt/mod_auth_cas

RUN autoreconf -ivf

RUN ./configure && make && make install

RUN make dist

ADD apache2.conf /apache2.conf

#ADD epl-server-ca.crt /epl-server-ca.crt

RUN mkdir /var/cache/apache2/mod_auth_cas/ -p

RUN chown -R www-data:www-data /var/cache/apache2/

RUN ln -s /epl-server.crt /etc/ssl/certs/ssl-cert-snakeoil.pem

RUN ln -s /epl-server.key /etc/ssl/private/ssl-cert-snakeoil.key

RUN a2enmod dav dav_svn

#RUN a2ensite default-ssl.conf

ADD default.conf /default.conf

ADD default_svn.conf /default_svn.conf

ADD default_tkblogs.conf /default_tkblogs.conf

ADD trustcert.sh /trustcert.sh

ADD mime.types /etc/mime.types

ADD apache2.conf /apache2.conf

ADD relocatesvn /relocatesvn

RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Luxembourg /etc/localtime
RUN echo "Europe/Luxembourg" > /etc/timezone

EXPOSE 443

VOLUME ["/var/log/apache2","/etc/php5/apache2/","/var/www/"]

# Config files.
COPY script/start.bash /root/start.bash

CMD ["/bin/bash", "/root/start.bash"]
