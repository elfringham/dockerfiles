FROM alpine

ARG APP_VERSION=?
ENV APP_VERSION=$APP_VERSION
ENV APPDIR=/srv/linaro-license-protection
ENV PORT=8080
ENV LLP_APP=linaro-license-protection.wsgi_production
ENV DJANGO_SETTINGS_MODULE=settings_production

# Setup flask application
RUN mkdir -p $APPDIR

WORKDIR $APPDIR

RUN apk --update --no-cache add python2 py2-pip mysql-client git py-gunicorn sqlite postgresql-dev && \
	apk --no-cache add gcc g++ python2-dev musl-dev && \
	git clone https://git.linaro.org/infrastructure/linaro-license-protection.git/ $APPDIR && \
	pip2 install --upgrade pip setuptools six && \
	pip2 install -r $APPDIR/requirements.txt && \
	apk del gcc g++ python3-dev musl-dev

EXPOSE $PORT

# Start gunicorn
COPY ./ /srv
WORKDIR /srv
CMD ["/srv/docker_run.sh"]