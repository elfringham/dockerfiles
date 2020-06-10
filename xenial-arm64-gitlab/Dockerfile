FROM ubuntu:bionic as builder

# Install required packages
RUN apt-get update -q \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      build-essential \
      autoconf \
      automake \
      autopoint \
      zlib1g-dev \
      byacc \
      cmake \
      python-pip \
      git \
      gcc \
      g++ \
      gcc-6 \
      g++-6 \
      libssl1.0-dev \
      libyaml-dev \
      libffi-dev \
      libreadline-dev \
      libgdbm-dev \
      libncurses5-dev \
      make \
      bzip2 \
      curl \
      ca-certificates \
      locales \
      openssh-server \
      libexpat1-dev \
      gettext \
      libz-dev \
      fakeroot \
      python-dev \
      python-setuptools \
      ccache \
      distcc \
      unzip \
      tzdata \
      apt-transport-https \
      gnupg

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN pip install awscli

ENV GO_VERSION 1.13.9
RUN curl -fsSL "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-arm64.tar.gz" \
	| tar -xzC /usr/local \
  && ln -sf /usr/local/go/bin/go /usr/local/go/bin/gofmt /usr/local/go/bin/godoc /usr/local/bin/

ENV RUBY_VERSION 2.6.5
RUN curl -fsSL "https://cache.ruby-lang.org/pub/ruby/2.6/ruby-${RUBY_VERSION}.tar.gz" \
  | tar -xzC /tmp \
  && cd /tmp/ruby-${RUBY_VERSION} \
  && ./configure --disable-install-rdoc --disable-install-doc --disable-install-capi\
  && make \
  && make install

ENV RUBYGEMS_VERSION 2.6.13
RUN /usr/local/bin/gem update --system ${RUBYGEMS_VERSION} --no-document

ENV BUNDLER_VERSION 1.17.3
RUN /usr/local/bin/gem install bundler --version ${BUNDLER_VERSION} --no-document

ENV LICENSE_FINDER_VERSION 3.1.1
RUN /usr/local/bin/gem install license_finder --version ${LICENSE_FINDER_VERSION} --no-document

ENV NODE_VERSION 12.4.0
RUN curl -fsSL "https://nodejs.org/download/release/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-arm64.tar.gz" \
  | tar --strip-components 1 -xzC /usr/local/ \
  && node --version

ENV YARN_VERSION 1.16.0
RUN mkdir /usr/local/yarn \
  && curl -fsSL "https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz" \
	| tar -xzC /usr/local/yarn --strip 1 \
  && ln -sf /usr/local/yarn/bin/yarn /usr/local/bin/ \ 
  && yarn --version

RUN mkdir -p /opt/gitlab /var/cache/omnibus ~/.ssh

RUN git config --global user.email "packages@gitlab.com"
RUN git config --global user.name "GitLab Inc."

RUN rm -rf /tmp/*

FROM ubuntu:bionic
MAINTAINER GitLab Inc. <support@gitlab.com>
COPY --from=builder / /
