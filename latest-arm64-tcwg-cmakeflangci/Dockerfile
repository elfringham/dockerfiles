FROM nginx:latest

# Install packages
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 build-essential \
 cmake \
 cron \
 file \
 git \
 libssl-dev \
 ninja-build \
 pkg-config \
 wget \
 xz-utils \
 && rm -rf \
  /var/lib/apt/lists/* \
  /tmp/* \
  /var/tmp/*

# Install a recent enough LLVM release (needs to be at least LLVM 15)
RUN \
 clang_ver=15.0.2 \
 && archive_name=clang+llvm-$clang_ver-aarch64-linux-gnu \
 && cd /usr/local \
 && wget --progress=dot:giga https://github.com/llvm/llvm-project/releases/download/llvmorg-$clang_ver/$archive_name.tar.xz \
 && tar xf $archive_name.tar.xz --strip-components=1 \
 && rm $archive_name.tar.xz

# Setup CMake scripts:
# https://gitlab.kitware.com/cmake/cmake/-/blob/master/Help/dev/testing.rst
RUN \
 scripts_dir=/ci/Dashboards \
 && mkdir -p $scripts_dir \
 && cd $scripts_dir \
 && git clone https://gitlab.kitware.com/cmake/dashboard-scripts.git CMakeScripts

COPY flang_dashboard.cmake "/ci/Dashboards/CMakeScripts/flang_dashboard.cmake"

RUN echo "0 2 * * * PATH=/usr/local/bin:$PATH ctest -S /ci/Dashboards/CMakeScripts/flang_dashboard.cmake -V" | crontab -

CMD ["bash", "-c", "service cron start && exec nginx -g 'daemon off;'"]

