FROM java:openjdk-8u102-jre

RUN mkdir /opt/appserver
RUN mkdir /var/www

RUN apt-get update && apt-get install -y python python-lxml bc gnuplot

ENV PATH $PATH:/opt/appserver/tools/trespass-svn.itrust.lu/ATtop/uppaal64-4.1.19-trespass/bin-Linux/

ADD manage.sh /manage.sh
#ADD trustcert.sh /trustcert.sh

RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Luxembourg /etc/localtime
RUN echo "Europe/Luxembourg" > /etc/timezone

VOLUME ["/opt/appserver/", "/var/www/"]

CMD ["/manage.sh"]
