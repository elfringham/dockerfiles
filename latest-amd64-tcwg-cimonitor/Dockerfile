FROM nginx:latest

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 cron \
 git \
 libjson-perl \
 libwww-perl \
 python3 \
 python3-pip \
 wget \
 && pip3 install requests pybuildkite python-dateutil pyyaml scp \
 && git clone https://git.linaro.org/toolchain/jenkins-scripts.git \
 && rm -rf /usr/share/nginx/html \
 && ln -s /public_html /usr/share/nginx/html \
 && mkdir -p /public_html \
 && echo "*/5 * * * * git -C /jenkins-scripts pull >/dev/null 2>&1 && /jenkins-scripts/generate-cimonitor-dashboard.py /jenkins-scripts/cimonitor-configs/CI-TCWG.yaml --output /public_html > /tmp/generate-cimonitor-dashboard.trace 2>&1" | crontab - \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

CMD ["bash", "-c", "service cron start && exec nginx -g 'daemon off;'"]

# docker run -d -p 8080:80 --name cimonitor linaro/ci-amd64-tcwg-cimonitor-nginx
