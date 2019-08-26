# Install and sets up ansible image ready for docker use

FROM ubuntu:18.04

LABEL maintainer="Linaro Systems Team <systems@linaro.org>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends gnupg software-properties-common
COPY *.list *.key /etc/apt/sources.list.d/

RUN apt-key add /etc/apt/sources.list.d/*.key \
 && apt-add-repository -y ppa:ansible/ansible \
 && apt-get update \
 && apt-get install -y ansible vim bash openssh-server python-apt sudo cron

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD /bin/sleep infinity
