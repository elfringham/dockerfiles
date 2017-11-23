FROM nginx:latest

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 cron \
 git \
 libjson-perl \
 libwww-perl \
 && git clone https://git.linaro.org/toolchain/llvm/linaro-scripts.git \
 && /linaro-scripts/monitor/install.sh /linaro-scripts-monitor \
 && rm -rf /usr/share/nginx/html \
 && ln -s /linaro-scripts-monitor/html /usr/share/nginx/html \
 && echo "*/5 * * * * /linaro-scripts-monitor/bin/bot-status /linaro-scripts-monitor/bin/linaro.json /linaro-scripts-monitor/html/index.html" | crontab - \
 && rm -rf \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

CMD ["bash", "-c", "service cron start && exec nginx -g 'daemon off;'"]

# docker run -d -p 80:80 --name llvmmonitor linaro/ci-amd64-tcwg-llvmmonitor-nginx
