#!/bin/sh

sudo debootstrap --arch=armhf --variant=minbase jessie debian-jessie-armhf http://http.debian.net/debian
sudo debootstrap --arch=arm64 --variant=minbase jessie debian-jessie-arm64 http://http.debian.net/debian

sudo debootstrap --arch=armhf --variant=minbase stretch debian-stretch-armhf http://deb.debian.org/debian
sudo debootstrap --arch=arm64 --variant=minbase stretch debian-stretch-arm64 http://deb.debian.org/debian

sudo debootstrap --arch=armhf --variant=minbase trusty ubuntu-trusty-armhf http://ports.ubuntu.com
sudo debootstrap --arch=arm64 --variant=minbase trusty ubuntu-trusty-arm64 http://ports.ubuntu.com

sudo debootstrap --arch=armhf --variant=minbase xenial ubuntu-xenial-armhf http://ports.ubuntu.com
sudo debootstrap --arch=arm64 --variant=minbase xenial ubuntu-xenial-arm64 http://ports.ubuntu.com
