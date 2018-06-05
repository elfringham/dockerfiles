# Auto generated from tcwg-base/tcwg-host/Dockerfile.in. Do not edit.
FROM linaro/ci-arm64-tcwg-base-ubuntu:xenial

COPY passwd start.sh /
COPY home/ /home-data/

RUN new-user.sh --group tcwg-infra:9000 && new-user.sh --group primary:10000 \
 && while read line; do \
      new-user.sh --passwd "$line"; \
      user=$(echo "$line" | cut -d: -f 1); \
      gid=$(echo "$line" | cut -d: -f 4); \
      chown -R $user:$gid /home-data/$user/; \
      rsync -a /home-data/$user/ /home/$user/; \
    done </passwd \
 && rm -rf /passwd /home-data/
# checksum: c86a4054a024547022a39736bfef0604
