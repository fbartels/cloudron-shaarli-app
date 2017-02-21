#!/bin/bash

set -eu

mkdir -p /app/data/data-dir/

# Create 'regular' conf files so that they are immediately writable
cp -u /app/code/data.orig/.htaccess /app/data/data-dir/
cp -u /app/code/data.orig/.htaccess /run/shaarli/cache/
cp -u /app/code/data.orig/.htaccess /run/shaarli/pagecache/
cp -u /app/code/data.orig/.htaccess /run/shaarli/tmp/

chown -R www-data:www-data /app/data /run/shaarli

echo "Starting apache"
APACHE_CONFDIR="" source /etc/apache2/envvars
rm -f "${APACHE_PID_FILE}"
exec /usr/sbin/apache2 -DFOREGROUND
