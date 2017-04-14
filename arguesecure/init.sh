#!/bin/bash

: ${DB_HOST:-mysql}
: ${DB_NAME:-arguesecure}
: ${DB_USER:-arguesecure}
: ${DB_PASS:-arguesecure}

sed -i 's#<DB_HOST>#'"${DB_HOST}"'#' .env
sed -i 's#<DB_NAME>#'"${DB_NAME}"'#' .env
sed -i 's#<DB_USER>#'"${DB_USER}"'#' .env
sed -i 's#<DB_PASS>#'"${DB_PASS}"'#' .env

cd /var/www/laravel/
php artisan migrate

nohup node server/server.js >/logs 2>&1 &

/usr/sbin/apache2ctl -D FOREGROUND
