FROM ubuntu:bionic

RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y --no-install-recommends apache2 ca-certificates ssl-cert

VOLUME /etc/apache/ /etc/ssl /etc/dehydrated /srv/certbot /var/log/apache
EXPOSE 443
CMD ["/usr/sbin/apache2ctl", "-D",  "FOREGROUND" ]


