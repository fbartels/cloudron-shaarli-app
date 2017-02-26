#!/bin/bash

set -eu

mkdir -p /app/data/data-dir/ /app/data/tpl /app/data/plugins

# distribute .htaccess to r/w dirs
cp -u /app/code/data.orig/.htaccess /app/data/data-dir/
cp -u /app/code/data.orig/.htaccess /run/shaarli/cache/
cp -u /app/code/data.orig/.htaccess /run/shaarli/pagecache/
cp -u /app/code/data.orig/.htaccess /run/shaarli/tmp/

cp -u /app/code/tpl.orig/* /app/data/tpl
cp -ru /app/code/plugins.orig/* /app/data/plugins

chown -R www-data:www-data /app/data /run/shaarli

echo "Starting apache"
APACHE_CONFDIR="" source /etc/apache2/envvars
rm -f "${APACHE_PID_FILE}"
exec /usr/sbin/apache2 -DFOREGROUND
