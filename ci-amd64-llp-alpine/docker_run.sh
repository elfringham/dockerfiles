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

    if [ ! -z "$DJANGO_MIGRATE" ]; then
        python $APPDIR/manage.py migrate --noinput
    fi
    if [ ! -z "$DJANGO_COLLECTSTATIC" ]; then
        python $APPDIR/manage.py collectstatic --noinput
    fi

    exec /usr/bin/gunicorn -w4 -b 0.0.0.0:$PORT $LLP_APP
fi

python $APPDIR/manage.py migrate --noinput --settings=settings
exec python $APPDIR/manage.py runserver 0.0.0.0:8080 --settings=settings
