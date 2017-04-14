FROM tomcat:8-jre8

RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get install -y maven

ADD tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

ENV CAS_VERSION 4.2.2

WORKDIR /opt

ADD https://github.com/apereo/cas/archive/v$CAS_VERSION.tar.gz v$CAS_VERSION.tar.gz

RUN tar xzf v$CAS_VERSION.tar.gz

WORKDIR /opt/v$CAS_VERSION

ADD pom.xml pom.xml

ADD *.woff /opt/woffs/

ADD font.css /opt/

RUN mvn clean install

RUN cp target/cas.war /app.war

ADD initenv /initenv
ADD local_policy.jar /local_policy.jar
ADD US_export_policy.jar /US_export_policy.jar
ADD .keystore /keystore-tomcat
ADD mycert.p12 /mycert.p12
ADD server.xml /server.xml
ADD cas.properties /cas.properties
ADD logo.png /logo.png
ADD deployerConfigContext.xml /deployerConfigContext.xml
ADD HTTPS-10000001.json /HTTPS-10000001.json
ADD casServiceValidationSuccess.jsp /casServiceValidationSuccess.jsp

RUN chmod 755 /initenv

WORKDIR /usr/local/tomcat/webapps/

RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Luxembourg /etc/localtime
RUN echo "Europe/Luxembourg" > /etc/timezone

EXPOSE 443

ENTRYPOINT ["/initenv"]
