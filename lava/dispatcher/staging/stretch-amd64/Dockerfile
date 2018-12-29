FROM debian:stretch

# Docker image for LAVA dispatcher with master branch, built daily.

LABEL maintainer="senthil.kumaran@linaro.org"

# Install the required dependencies
RUN echo 'locales locales/locales_to_be_generated multiselect C.UTF-8 UTF-8, en_US.UTF-8 UTF-8 ' | debconf-set-selections && \
    echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install ntp git tftpd-hpa openbsd-inetd ser2net qemu-kvm \
    qemu-system-x86 qemu-system-arm qemu-user-static libguestfs-tools \
    nfs-kernel-server rpcbind u-boot-tools unzip xz-utils debootstrap \
    bridge-utils dfu-util img2simg emacs-nox vim gnupg2 sed expect grep wget \
    openssh-server adb fastboot simg2img img2simg

# Add LAVA stretch-backports staging repo
RUN wget -qO - http://images.validation.linaro.org/staging-repo/staging-repo.key.asc | apt-key add - && \
    echo "deb http://images.validation.linaro.org/staging-repo stretch-backports main" >/etc/apt/sources.list.d/linaro.list

RUN echo 'locales locales/locales_to_be_generated multiselect C.UTF-8 UTF-8, en_US.UTF-8 UTF-8 ' | debconf-set-selections && \
    echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y -t stretch-backports install lava-common lava-dispatcher \
    lava-lxc-mocker && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose services ports
EXPOSE 22

# Set entrypoint script
COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

# Following is a sample docker run command to use this image
#
# sudo docker run -v /boot:/boot -v /lib/modules:/lib/modules \
# -v /var/run/docker.sock:/var/run/docker.sock -itd -e HOSTNAME='worker-1' \
# -e MASTER='tcp://192.168.1.2:5556' -e SOCKET_ADDR='tcp://192.168.1.2:5555' \
# -e LOG_LEVEL='DEBUG' -p 2222:22 --privileged \
# --name ld-2017.12 stylesen/lava-dispatcher:2017.12
