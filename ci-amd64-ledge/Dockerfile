FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

ENV PKGS="\
    git \
    ca-certificates \
    qemu-system-arm \
    qemu-system-x86 \
    qemu-system-gui- \
    swtpm \
"

RUN set -e ;\
    apt-get update -q=2 ;\
    apt-get full-upgrade -q=2 --yes ;\
    apt-get install -q=2 --yes --no-install-recommends ${PKGS} ;\
    # Build QEMU
    git clone -b v2 https://gitlab.com/terceiro/qemu-swtpm.git /tmp/qemu-swtpm ;\
    cd /tmp/qemu-swtpm ;\
    ./install.sh ;\
    # Cleanup
    apt clean ;\
    rm -rf /var/lib/apt/lists/* /tmp/*
