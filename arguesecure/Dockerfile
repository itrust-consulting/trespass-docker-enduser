FROM eboraas/apache-php:latest
RUN apt-get update && apt-get -y install git curl php5-mcrypt php5-json php5-memcached && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN /usr/sbin/a2enmod rewrite
ADD 000-laravel.conf /etc/apache2/sites-available/
ADD 001-laravel-ssl.conf /etc/apache2/sites-available/
RUN /usr/sbin/a2dissite '*' && /usr/sbin/a2ensite 000-laravel 001-laravel-ssl
RUN /usr/bin/curl -sS https://getcomposer.org/installer |/usr/bin/php
RUN /bin/mv composer.phar /usr/local/bin/composer
RUN /usr/local/bin/composer create-project laravel/laravel /var/www/laravel --prefer-dist
RUN /bin/chown www-data:www-data -R /var/www/laravel/storage /var/www/laravel/bootstrap/cache

WORKDIR /var/www/laravel/

RUN find . -delete

RUN ls -la .

RUN git clone https://github.com/hitandyrun/arguesecure-online.git .

RUN composer install

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

RUN sed -i 's/DB_HOST=localhost/DB_HOST=<DB_HOST>/' .env
RUN sed -i 's/DB_DATABASE=argue/DB_DATABASE=<DB_NAME>/' .env
RUN sed -i 's/DB_USERNAME=homestead/DB_USERNAME=<DB_USER>/' .env
RUN sed -i 's/DB_PASSWORD=secret/DB_PASSWORD=<DB_PASS>/' .env
RUN sed -i "s#'url' => 'http://argue.app',#'url' => 'http://node:3002',#" config/app.php
RUN sed -i "s#WEBSOCKET_IP = http://argue.app#WEBSOCKET_IP = http://arguesecure-node#" .env
RUN sed -i "s#'host' => '127.0.0.1', 'port' => 11211,#'host' => 'arguesecure-memcached', 'port' => 11211,#" ./config/cache.php
RUN sed -i "s#'host'     => '127.0.0.1',#'host'     => 'arguesecure-redis',#" config/database.php
RUN sed -i "s#'enabled' => null,#'enabled' => false,#" config/debugbar.php

RUN mkdir logs

RUN chown -R www-data:www-data /var/www/

ADD init.sh /init.sh

RUN chmod +x /init.sh

RUN echo "" >> .env
RUN echo "PROXY_URL = https://tp-arguesecure.itrust.lu" >> .env
RUN echo "PROXY_SCHEMA = https" >> .env

RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Luxembourg /etc/localtime
RUN echo "Europe/Luxembourg" > /etc/timezone

EXPOSE 80 
EXPOSE 443 
ENTRYPOINT ["/init.sh"]
