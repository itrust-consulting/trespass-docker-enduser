FROM python:3.5.1-onbuild

EXPOSE 80

RUN openssl req \
    -new \
    -newkey rsa:4096 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=LU/ST=cherrypy/L=cherrypy/O=cherrypy/CN=cherrypy.itrust.lu" \
    -keyout /cherrypy.key \
    -out /cherrypy.crt

RUN openssl req \
    -new \
    -newkey rsa:4096 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=LU/ST=cherrypy/L=cherrypy/O=cherrypy/CN=cherrypy-ca.itrust.lu" \
    -keyout /cherrypy-ca.key \
    -out /cherrypy-ca.crt

RUN openssl req -subj "/C=LU/ST=cherrypy/L=cherrypy/O=cherrypy/CN=cherrypy.itrust.lu" -new -key /cherrypy.key -out /cherrypy.csr

RUN openssl x509 -req -days 9000 -in /cherrypy.csr -CA /cherrypy-ca.crt -CAkey /cherrypy-ca.key -set_serial 001 -out /cherrypy.crt

RUN apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
	&& rm -rf /var/lib/apt/lists/*

RUN echo 'deb http://httpredir.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list

ENV LANG C.UTF-8

RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre

ENV JAVA_VERSION 8u121
ENV JAVA_DEBIAN_VERSION 8u121-b13-1~bpo8+1

ENV CA_CERTIFICATES_JAVA_VERSION 20161107~bpo8+1

RUN set -x \
	&& apt-get update \
	&& apt-get install -y -t jessie-backports  \
		openjdk-8-jre-headless \
		ca-certificates-java \
	&& rm -rf /var/lib/apt/lists/* \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]

# see CA_CERTIFICATES_JAVA_VERSION notes above
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

ADD manage.sh /manage.sh

RUN mkdir /opt/svn

RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Luxembourg /etc/localtime
RUN echo "Europe/Luxembourg" > /etc/timezone

VOLUME ["/opt/svn/"]

CMD [ "/manage.sh" ]
