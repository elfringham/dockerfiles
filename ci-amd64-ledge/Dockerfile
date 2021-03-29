FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
ENV PKG_DEPS="\
  build-essential \
  ca-certificates \
  git \
  gnutls-dev \
  libaio-dev \
  libattr1-dev \
  libbrlapi-dev \
  libcacard-dev \
  libcap-ng-dev \
  libfdt-dev \
  libgcrypt-dev \
  libgl1-mesa-dev \
  libgtk-3-dev \
  libibumad-dev \
  libibverbs-dev \
  libiscsi-dev \
  liblzo2-dev \
  libnfs-dev \
  librbd-dev \
  librdmacm-dev \
  libsdl2-dev \
  libseccomp-dev \
  libspice-protocol-dev \
  libusb-dev \
  libvde-dev \
  libvdeplug-dev \
  libvte-dev \
  lsof \
  nettle-dev \
  ninja-build \
  patch \
  python \
  wget \
  xfslibs-dev \
"

RUN set -e ;\
    apt update -q=2 ;\
    apt full-upgrade -q=2 --yes ;\
    apt install -q=2 --yes --no-install-recommends ${PKG_DEPS} ;\
    # Build QEMU
    git clone -b v5.2.0 --depth 1 https://git.qemu.org/git/qemu.git /tmp/qemu ;\
    cd /tmp/qemu ;\
    wget -O 1.patch https://raw.githubusercontent.com/Linaro/meta-ledge/dunfell/meta-ledge-bsp/recipes-devtools/qemu/qemu/0001-hw-gpio-implement-gpio-pwr-driver-for-qemu-reset-pow.patch ;\
    patch -p1 < 1.patch ;\
    wget -O 2.patch https://raw.githubusercontent.com/Linaro/meta-ledge/dunfell/meta-ledge-bsp/recipes-devtools/qemu/qemu/0002-arm-virt-refactor-gpios-creation.patch ;\
    patch -p1 < 2.patch ;\
    wget -O 3.patch https://raw.githubusercontent.com/Linaro/meta-ledge/dunfell/meta-ledge-bsp/recipes-devtools/qemu/qemu/0003-arm-virt-add-secure-pl061-for-reset-power-down.patch ;\
    patch -p1 < 3.patch ;\
    mkdir -p build ;\
    cd build ;\
    TARGETS="aarch64 arm x86_64" ;\
    ../configure --target-list="$(for tg in $TARGETS; do echo -n ${tg}'-softmmu '; done)" --prefix=/usr ;\
    make -j$(nproc) ;\
    make install ;\
    # Cleanup
    apt clean ;\
    rm -rf /var/lib/apt/lists/* /tmp/*
