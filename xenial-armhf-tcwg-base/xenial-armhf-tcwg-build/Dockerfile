# Auto generated from tcwg-base/tcwg-build/Dockerfile.in. Do not edit.
FROM linaro/ci-armhf-tcwg-base-ubuntu:xenial

COPY tcwg-buildslave /home-data/tcwg-buildslave
COPY tcwg-benchmark /home-data/tcwg-benchmark

RUN new-user.sh --group tcwg-infra:9000 \
 && new-user.sh --passwd "tcwg-buildslave:x:11827:9000:TCWG Buildslave::/bin/bash" --home-data /home-data \
 && new-user.sh --passwd "tcwg-benchmark:x:12326:9000:TCWG Benchmark::/bin/bash" --home-data /home-data \
 && rm -rf /home-data/ \
 && mkdir -p /home/tcwg-buildslave/workspace

# checksum: fbf6f8e32515f6bf9650f47e5c9f744b
