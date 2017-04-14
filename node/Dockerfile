FROM node:6.9.1
RUN apt-get update && apt-get -y install git
WORKDIR /opt

RUN git clone https://github.com/hitandyrun/arguesecure-online.git .

RUN npm install

ADD init.sh /init.sh

RUN chmod +x /init.sh

RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Luxembourg /etc/localtime
RUN echo "Europe/Luxembourg" > /etc/timezone

EXPOSE 3002 
ENTRYPOINT ["/init.sh"]
