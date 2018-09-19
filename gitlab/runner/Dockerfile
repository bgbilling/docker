FROM openjdk:8-jdk-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    bzip2 \
    unzip \
    xz-utils \
    wget \
    curl \
    netcat \
    ca-certificates \
#    sudo \
    procps \
    openjfx \
    git \
    mysql-client \
    openssh-client \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/apk/* \
  && rm -fr /tmp/* /var/tmp/*