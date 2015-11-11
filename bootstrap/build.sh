#!/bin/sh

sudo debootstrap --arch=armhf --variant=minbase jessie debian-jessie-armhf http://http.debian.net/debian
sudo debootstrap --arch=arm64 --variant=minbase jessie debian-jessie-arm64 http://http.debian.net/debian

sudo debootstrap --arch=armhf --variant=minbase trusty ubuntu-trusty-armhf http://ports.ubuntu.com
sudo debootstrap --arch=arm64 --variant=minbase trusty ubuntu-trusty-arm64 http://ports.ubuntu.com

sudo debootstrap --arch=armhf --variant=minbase vivid ubuntu-vivid-armhf http://ports.ubuntu.com
sudo debootstrap --arch=arm64 --variant=minbase vivid ubuntu-vivid-arm64 http://ports.ubuntu.com

sudo debootstrap --arch=armhf --variant=minbase wily ubuntu-wily-armhf http://ports.ubuntu.com
sudo debootstrap --arch=arm64 --variant=minbase wily ubuntu-wily-arm64 http://ports.ubuntu.com
