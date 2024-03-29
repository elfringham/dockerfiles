FROM jenkins/jenkins:2.375.1-lts-slim

ENV JENKINS_JAVA_PARAMETERS="-server -XX:+AlwaysPreTouch -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/jenkins/heapdump.log -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+ParallelRefProcEnabled -XX:+ExplicitGCInvokesConcurrent -XX:+UnlockDiagnosticVMOptions -XX:G1SummarizeRSetStatsPeriod=1 -XX:MaxMetaspaceExpansion=64M -Djenkins.model.Jenkins.logStartupPerformance=true"
ENV JAVA_OPTS="$JENKINS_JAVA_PARAMETERS -Djava.awt.headless=true -Dhudson.slaves.WorkspaceList='_' -Dhudson.model.ParametersAction.keepUndefinedParameters=true -Dorg.jenkinsci.plugins.gitclient.Git.timeOut=30 -Dorg.eclipse.jetty.server.Request.maxFormContentSize=1000000"
ENV JENKINS_OPTS="--sessionTimeout=1440 --sessionEviction=86400"
ENV JAVA_MEM=${JAVA_MEM:-8}

# Install jenkins job builder
# Create plugins directory, symlinked on host machine
USER root
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  wget \
  gettext \
  jq \
  build-essential \
  moreutils \
  python3-paramiko \
  python3-requests \
  python3-setuptools \
  python3-wheel \
  sshpass \
  virtualenv \
  && apt-get clean \
  && rm -rf \
  /var/lib/apt/lists/* \
  && mkdir -p /var/jenkins_plugins \
  && chown jenkins:jenkins /var/jenkins_plugins \
  && ln -s /var/jenkins_home /var/lib/jenkins \
  && mkdir -p /usr/share/groovy/lib \
  && wget -q https://search.maven.org/remotecontent?filepath=org/codehaus/groovy/groovy-xmlrpc/0.8/groovy-xmlrpc-0.8.jar -O /usr/share/groovy/lib/groovy-xmlrpc-0.8.jar \
  && wget -q https://storage.googleapis.com/git-repo-downloads/repo -O /usr/bin/repo\
  && chmod +x /usr/bin/repo

USER jenkins

# Install jenkins plugins
COPY plugins.txt .
RUN jenkins-plugin-cli -f plugins.txt \
  && wget -q https://jenkins-linaro-pubapi.s3.amazonaws.com/linaro-pubapi-1.3.hpi -O /usr/share/jenkins/ref/plugins/linaro-pubapi-1.3.hpi

# Forward ports to host
EXPOSE 2222
