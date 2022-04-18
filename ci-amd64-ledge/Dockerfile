FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

ENV PKGS="\
    git \
    ca-certificates \
    qemu-system-arm \
    qemu-system-x86 \
    qemu-system-gui- \
"

RUN set -e ;\
    apt-get update -q=2 ;\
    apt-get full-upgrade -q=2 --yes ;\
    apt-get install -q=2 --yes --no-install-recommends ${PKGS} ;\
    # Build QEMU
    # Cleanup
    apt clean ;\
    rm -rf /var/lib/apt/lists/* /tmp/*
