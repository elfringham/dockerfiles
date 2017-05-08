FROM ubuntu:xenial

COPY *.list *.key /etc/apt/sources.list.d/

RUN dpkg --add-architecture i386 \
 && echo 'deb http://archive.ubuntu.com/ubuntu/ xenial multiverse' > /etc/apt/sources.list.d/multiverse.list \
 && echo 'deb http://archive.ubuntu.com/ubuntu/ xenial-proposed main' > /etc/apt/sources.list.d/xenial-proposed.list \
 && echo 'Package: *' > /etc/apt/preferences.d/proposed-updates \
 && echo 'Pin: release a=xenial-proposed' >> /etc/apt/preferences.d/proposed-updates \
 && echo 'Pin-Priority: 400' >> /etc/apt/preferences.d/proposed-updates \
 && echo 'locales locales/locales_to_be_generated multiselect C.UTF-8 UTF-8, en_US.UTF-8 UTF-8 ' | debconf-set-selections \
 && echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections \
 && apt-key add /etc/apt/sources.list.d/*.key \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 ca-certificates \
 curl \
 file \
 git \
 lsb-release \
 make \
 openjdk-8-jdk \
 openssh-server \
 python-requests \
 sudo \
 wget \
 lib32z1/xenial-proposed \
 lib32z1-dev/xenial-proposed \
 zlib1g/xenial-proposed \
 zlib1g:i386/xenial-proposed \
 zlib1g-dev:i386/xenial-proposed \
 && wget -q \
 http://de.archive.ubuntu.com/ubuntu/pool/main/m/make-dfsg/make_3.81-8.2ubuntu3_amd64.deb \
 && dpkg -i --force-all *.deb \
 && apt-mark hold make \
 && apt-get clean

RUN useradd -m buildslave \
 && echo 'buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /var/run/sshd /home/buildslave/bin \
 && curl https://chromium.googlesource.com/chromium/src/build/+/master/install-build-deps.sh?format=TEXT | base64 -d > /home/buildslave/bin/install-build-deps.sh \
 && chmod a+x /home/buildslave/bin/* \
 && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /home/buildslave/depot_tools \
 && echo 'PATH="/home/buildslave/depot_tools:$PATH"' >> /home/buildslave/.profile \
 && chown -R buildslave:buildslave /home/buildslave/bin /home/buildslave/depot_tools \
 && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true | debconf-set-selections \
 && bash /home/buildslave/bin/install-build-deps.sh --no-syms --no-chromeos-fonts --no-prompt \
 && apt-get clean \
 && rm -rf \
 /etc/apt/sources.list.d/*.key \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/* \
 *.deb

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
