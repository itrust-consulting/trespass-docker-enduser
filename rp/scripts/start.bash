#!/bin/bash
if [ $APACHE_USER_UID != 0 ];then
	usermod -u $APACHE_USER_UID $APACHE_RUN_USER
fi

DNS_VALUE=${DNS_VALUE:-trespass.eu}

if [[ ! -e /certs/cert.crt ]]; then
	/root/init-ssl.sh
fi

cp /default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf

sed -i 's#<DNS_VALUE>#'"${DNS_VALUE}"'#' /etc/apache2/sites-enabled/default-ssl.conf


chown -R www-data:www-data /var/www
chown -R root:root /etc/apache2
chmod -R o-w /etc/apache2

/usr/sbin/apache2 -DFOREGROUND
