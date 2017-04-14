FROM debian:latest

ENV APACHE_RUN_USER  www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE  /var/run/apache2.pid
ENV APACHE_RUN_DIR   /var/run/apache2
ENV APACHE_LOCK_DIR  /var/lock/apache2
ENV APACHE_LOG_DIR   /var/log/apache2
ENV APACHE_USER_UID 0

# PHP && Apache
RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get -yqq install --no-install-recommends \
    openssl \
    apache2-mpm-prefork\
    apache2-utils \
    ca-certificates \
    php5 php5-mysql php5-gd \
    heirloom-mailx
RUN rm -rf /var/lib/apt/lists/*
RUN a2enmod rewrite ssl headers xml2enc deflate proxy* substitute
RUN for i in $(apache2 -M | egrep -v "authz_core|authz_host" | egrep 'auth.+_' | awk -F "_module" '{print $1}' | sed 's/ //g'); do \
a2dismod -f $i; \
done
RUN for i in $(apache2 -M | egrep -v "proxy_http|proxy_module" | egrep 'proxy_' | awk -F "_module" '{print $1}' | sed 's/ //g'); do \
a2dismod -f $i; \
done
RUN a2dismod -f status autoindex
ADD apache2.conf /etc/apache2/apache2.conf

# Config files.
COPY scripts/start.bash /root/start.bash
COPY scripts/init-ssl.sh /root/init-ssl.sh

RUN chmod +x /root/start.bash
RUN chmod +x /root/init-ssl.sh

EXPOSE 80 443

VOLUME ["/var/log/apache2","/etc/php5/apache2/","/var/www/"]

RUN rm /etc/apache2/sites-enabled/*

ADD default-ssl-bis.conf /etc/apache2/sites-available/default-ssl.conf

RUN a2ensite default-ssl.conf

RUN mkdir -p /var/lock/apache2

RUN rm -R /var/www/*

ADD security.conf /etc/apache2/conf-enabled/security.conf
ADD ssl.conf /etc/apache2/mods-enabled/ssl.conf

RUN sed -i "s#/var/www/html#/var/www#" /etc/apache2/sites-enabled/default-ssl.conf

RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Luxembourg /etc/localtime
RUN echo "Europe/Luxembourg" > /etc/timezone

RUN echo "Listen 80" > /etc/apache2/ports.conf
RUN echo "Listen 443" >> /etc/apache2/ports.conf

VOLUME ["/var/log/apache2"]
VOLUME ["/certs/"]

RUN sed -i 's/RequestReadTimeout body=10,minrate=500/RequestReadTimeout body=20,minrate=500/g' /etc/apache2/mods-available/reqtimeout.conf

RUN mkdir /keys

CMD ["/bin/bash", "/root/start.bash"]
