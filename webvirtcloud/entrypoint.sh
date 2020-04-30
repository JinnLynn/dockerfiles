#!/usr/bin/env sh

python3 manage.py migrate

exec supervisord -c /app/etc/supervisord.conf
