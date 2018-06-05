# Auto generated from tcwg-base/tcwg-host/Dockerfile.in. Do not edit.
FROM linaro/ci-amd64-tcwg-base-ubuntu:xenial

COPY authorized_keys-* passwd /

RUN new-user.sh --group primary:10000 \
 && while read line; do new-user.sh --passwd "$line"; done </passwd \
 && for key in /authorized_keys-*; do new-user.sh --key "$key"; done \
 && rm /passwd /authorized_keys-*

COPY start.sh /
# checksum: ba13ddbbe36a0811f7427be711400606
