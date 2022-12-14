#!/bin/sh -e

# if DJANGO_DEBUG is defined, we'll run via django with dynamic reloading of
# code changes to disk. This is helpful for debugging something already in k8s

if [ -z "$DJANGO_DEBUG" ] ; then
    # Double quotes are important, otherwise docker strips the newlines
    # These are set as a env in our playbook
    echo "$secrets_file" >> /srv/secrets.py
    echo "$allowed_hosts" >> /srv/allowed_hosts.txt
    if [ ! -z "$html_header" ] ; then
        echo "$html_header" >> /srv/header_override.html
    fi

    exec /usr/bin/gunicorn --timeout 180 -w4 -k gevent -b 0.0.0.0:$PORT $LLP_APP
fi

if [ ! -z "$DJANGO_MIGRATE" ]; then
   python $APPDIR/manage.py migrate --noinput --settings=$DJANGO_SETTINGS_MODULE
fi
if [ ! -z "$DJANGO_COLLECTSTATIC" ]; then
   python $APPDIR/manage.py collectstatic --noinput --settings=$DJANGO_SETTINGS_MODULE
fi

exec python $APPDIR/manage.py runserver 0.0.0.0:8080 --settings=$DJANGO_SETTINGS_MODULE
