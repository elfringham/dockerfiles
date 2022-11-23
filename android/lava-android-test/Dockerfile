# Use the official image as a parent image.
FROM ubuntu:18.04

# Set the working directory.
WORKDIR /linaro-android

RUN apt-get update \
 && apt-get install -y \
 aapt \
 apt-utils \
 coreutils \
 curl \
 git \
 lib32gcc1 \
 lib32z1-dev \
 libc6-dev-i386 \
 libcurl4 \
 openjdk-8-jdk-headless \
 openjdk-11-jdk-headless \
 protobuf-compiler \
 psmisc \
 python-dev \
 python-lxml \
 python-pexpect \
 python-pexpect \
 python-pip \
 python-protobuf \
 python-setuptools \
 python-virtualenv \
 sudo \
 tar \
 unzip \
 usbutils \
 wget \
 xz-utils \
 zip \
 && apt-get clean \
 && rm -rf \
 /etc/apt/sources.list.d/*.key \
 /var/lib/apt/lists/* \
 /tmp/* \
 /var/tmp/*

# https://developer.android.com/studio/releases/platform-tools
ADD https://dl.google.com/android/repository/platform-tools_r28.0.0-linux.zip .
RUN unzip platform-tools_r28.0.0-linux.zip
RUN rm -f /usr/bin/fastboot /usr/bin/adb && ln -s /linaro-android/platform-tools/fastboot /usr/bin/fastboot && ln -s /linaro-android/platform-tools/adb /usr/bin/adb
