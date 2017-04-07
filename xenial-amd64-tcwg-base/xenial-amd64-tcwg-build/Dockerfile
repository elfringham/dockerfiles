FROM linaro/ci-amd64-tcwg-base-ubuntu:xenial

RUN groupadd -g 9000 tcwg-infra \
 && useradd -m -g tcwg-infra -u 11827 tcwg-buildslave \
 && echo 'tcwg-buildslave ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins \
 && chmod 0440 /etc/sudoers.d/jenkins \
 && mkdir -p /home/tcwg-buildslave/workspace

COPY tcwg-buildslave /home/tcwg-buildslave
RUN chown -R tcwg-buildslave:tcwg-infra /home/tcwg-buildslave/ \
 && chmod 0700 /home/tcwg-buildslave/.ssh/

# Unfortunately, VOLUME doesn't support bind-mounts for portability reasons.
# Therefore, the bind-mounts for the following paths are configured in
# the ci.linaro.org's docker plugin.
# Sources caches (read-only):
# /home/tcwg-buildslave/snapshots-ref:/home/tcwg-buildslave/snapshots-ref:ro
# Jenkins .jar cache (read-write):
# /home/tcwg-buildslave/.jenkins:/home/tcwg-buildslave/.jenkins:rw

# We write most of the data inside workspace, so make it a scratch mount.
# Note that bind-mounting workspace from host will make jobs with parallel
# builds fail.
VOLUME /home/tcwg-buildslave/workspace
