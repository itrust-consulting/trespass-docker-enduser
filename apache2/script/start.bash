#!/bin/bash

set -e

DNS_VALUE=${DNS_VALUE:-trespass.eu}

CAS_COOKIE_PATH=/var/cache/apache2/mod_auth_cas/
CAS_LOGIN_URL="https://cas.$DNS_VALUE/"
CAS_VALIDATE_URL="https://cas.$DNS_VALUE/serviceValidate"
find / -wholename "/run/apache2.pid" -delete

APACHE_MODE=${APACHE_MODE:-svn}

if [ ! "$(ls -A /etc/apache2/sites-enabled)" ]; then
	if [ "$APACHE_MODE" = "svn" ]; then
		CAS_ROOT_PROXIEDAS="https://svn.$DNS_VALUE"
		ln -s /default_svn.conf /etc/apache2/sites-enabled/
	elif [ "$APACHE_MODE" = "cherrypy" ]; then
		CAS_ROOT_PROXIEDAS="https://$DNS_VALUE/tkb"
		ln -s /default.conf /etc/apache2/sites-enabled/
		cp /apache2.conf /etc/apache2/apache2.conf
		sed -i 's#<CAS_COOKIE_PATH>#'"${CAS_COOKIE_PATH}"'#' /etc/apache2/apache2.conf
		sed -i 's#<CAS_LOGIN_URL>#'"${CAS_LOGIN_URL}"'#' /etc/apache2/apache2.conf
		sed -i 's#<CAS_VALIDATE_URL>#'"${CAS_VALIDATE_URL}"'#' /etc/apache2/apache2.conf
		sed -i 's#<CAS_ROOT_PROXIEDAS>#'"${CAS_ROOT_PROXIEDAS}"'#' /etc/apache2/apache2.conf
	elif [ "$APACHE_MODE" = "tkblogs" ]; then
		CAS_ROOT_PROXIEDAS="https://tkblogs.$DNS_VALUE"
		ln -s /default_tkblogs.conf /etc/apache2/sites-enabled/
		cp /apache2.conf /etc/apache2/apache2.conf
		sed -i 's#<CAS_COOKIE_PATH>#'"${CAS_COOKIE_PATH}"'#' /etc/apache2/apache2.conf
		sed -i 's#<CAS_LOGIN_URL>#'"${CAS_LOGIN_URL}"'#' /etc/apache2/apache2.conf
		sed -i 's#<CAS_VALIDATE_URL>#'"${CAS_VALIDATE_URL}"'#' /etc/apache2/apache2.conf
		sed -i 's#<CAS_ROOT_PROXIEDAS>#'"${CAS_ROOT_PROXIEDAS}"'#' /etc/apache2/apache2.conf
	fi
fi

/trustcert.sh

if [ $APACHE_USER_UID != 0 ];then
  usermod -u $APACHE_USER_UID $APACHE_RUN_USER
fi
/usr/sbin/apache2 -DFOREGROUND
