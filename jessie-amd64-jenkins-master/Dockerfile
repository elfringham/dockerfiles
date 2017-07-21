FROM jenkinsci/jenkins:2.60.2

ENV JENKINS_JAVA_PARAMETERS="-server -XX:+AlwaysPreTouch -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/jenkins/heapdump.log -verbose:gc -Xloggc:/var/log/jenkins/gc-%t.log -XX:NumberOfGCLogFiles=2 -XX:+UseGCLogFileRotation -XX:GCLogFileSize=100m -XX:+PrintGC -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+PrintHeapAtGC -XX:+PrintGCCause -XX:+PrintTenuringDistribution -XX:+PrintReferenceGC -XX:+PrintAdaptiveSizePolicy -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+ParallelRefProcEnabled -XX:+ExplicitGCInvokesConcurrent -XX:+UnlockDiagnosticVMOptions -XX:G1SummarizeRSetStatsPeriod=1 -XX:MaxMetaspaceExpansion=64M -Djenkins.model.Jenkins.logStartupPerformance=true"
ENV JAVA_OPTS="-Xms4g -Xmx8g $JENKINS_JAVA_PARAMETERS -Djava.awt.headless=true -Dhudson.slaves.WorkspaceList='_' -Dhudson.model.ParametersAction.keepUndefinedParameters=true -Dorg.jenkinsci.plugins.gitclient.Git.timeOut=30 -Dorg.eclipse.jetty.server.Request.maxFormContentSize=1000000"
ENV JENKINS_OPTS="--sessionTimeout=1440"

# Install jenkins job builder
# Create plugins directory, symlinked on host machine
USER root
RUN wget -q https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py \
  && python /tmp/get-pip.py \
  && rm -f /tmp/get-pip.py \
  && pip install jenkins-job-builder==1.6.2 \
  && git clone --depth 1 https://git.linaro.org/infrastructure/jjb-linaro-plugin.git \
  && cd jjb-linaro-plugin && python setup.py install \
  && cd .. && rm -rf jjb-linaro-plugin \
  && mkdir -p /var/jenkins_plugins \
  && chown jenkins:jenkins /var/jenkins_plugins \
  && ln -s /var/jenkins_home /var/lib/jenkins \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  debian-keyring \
  devscripts \
  dput \
  python-paramiko \
  python-requests \
  && wget -q https://launchpad.net/ubuntu/+archive/primary/+files/dput_0.9.6.4ubuntu3_all.deb \
  && dpkg -i --force-all *.deb \
  && apt-get clean \
  && rm -rf \
  /var/lib/apt/lists/* \
  *.deb
USER jenkins

# Install jenkins plugins
COPY plugins.txt .
RUN install-plugins.sh $(echo $(cat plugins.txt)) \
  && wget -q http://people.linaro.org/~paul.sokolovsky/jenkins/linaro-pubapi-1.3.hpi -O /usr/share/jenkins/ref/plugins/linaro-pubapi-1.3.hpi

# Forward ports to host
EXPOSE 2222
