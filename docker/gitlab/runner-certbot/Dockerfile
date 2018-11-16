FROM debian:stretch-slim

RUN echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list.d/backports.list \
  && apt-get update && apt-get install -y --no-install-recommends \
    certbot -t stretch-backports \
    bzip2 \
    unzip \
    xz-utils \
    wget \
    curl \
    netcat \
    ca-certificates \
    procps \
    openssh-client \
    sshfs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/apk/* \
  && rm -fr /tmp/* /var/tmp/*