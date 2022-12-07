# Use the official image as a parent image.
FROM linaro/kir:master

# Set the working directory.
WORKDIR /linaro-android

RUN apt-get update \
 && apt-get install -y \
 bc \
 jq \
 rsync \
 selinux-utils \
 sudo \
 time \
 wget \
 && apt-get clean \
 && rm -rf \
 /etc/apt/sources.list.d/*.key \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*


ADD https://android-git.linaro.org/android-build-configs.git/plain/lkft/linaro-lkft-android-docker.sh?h=lkft /usr/bin/linaro-lkft-android.sh
RUN chmod +x /usr/bin/linaro-lkft-android.sh
