FROM sameersbn/mysql

ADD init-databases-users.sql /init-databases-users.sql
ADD update-link-tools /update-link-tools
RUN chmod +x /init-databases-users.sql

RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Luxembourg /etc/localtime
RUN echo "Europe/Luxembourg" > /etc/timezone
