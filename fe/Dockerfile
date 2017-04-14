FROM tomcat:8.0.43-jre8

ENV MYSQL_CONNECTOR_VERSION 5.1.39

RUN apt-get update && apt-get install -y mysql-client

ADD tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

ADD http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$MYSQL_CONNECTOR_VERSION.tar.gz /tmp

WORKDIR /tmp

RUN tar xvzf mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.tar.gz mysql-connector-java-${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}-bin.jar

RUN mv mysql-connector-java-${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}-bin.jar /usr/local/tomcat/lib/

ADD trespass.war /app.war
ADD initenv /initenv
ADD application.properties /application.properties
ADD local_policy.jar /local_policy.jar
ADD US_export_policy.jar /US_export_policy.jar
ADD tomcat.jks /keystore-tomcat
ADD server.xml /server.xml
ADD trustcert.sh /trustcert.sh

RUN chmod 755 /initenv

WORKDIR /usr/local/tomcat/webapps/

RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Luxembourg /etc/localtime
RUN echo "Europe/Luxembourg" > /etc/timezone

EXPOSE 443

ENTRYPOINT ["/initenv"]
