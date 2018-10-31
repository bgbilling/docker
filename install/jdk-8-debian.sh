#!/bin/sh -eux

[ ! -f /opt/activemq ]

JAVA_VERSION=8u181
JAVA_DEBIAN_VERSION=8u181-b13-1~deb9u1

CA_CERTIFICATES_JAVA_VERSION=20170531+nmu1

JAVA_HOME=/opt/java/jdk8

{ \
  echo '#!/bin/sh'; \
  echo 'set -e'; \
  echo; \
  echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
} > /tmp/check-java-home \
  && chmod +x /tmp/check-java-home

mkdir -p /opt/java \
  && ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /opt/java/jdk8

#apt-get install -y --no-install-recommends \
#  openjdk-8-jdk="$JAVA_DEBIAN_VERSION" \
#  ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION"
  
apt-get install -y --no-install-recommends \
  openjdk-8-jdk \
  ca-certificates-java

[ "$(readlink -f "$JAVA_HOME")" = "$(/tmp/check-java-home)" ]

update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'
update-alternatives --query java | grep -q 'Status: manual'

/var/lib/dpkg/info/ca-certificates-java.postinst configure

{ \
  echo '#!/bin/sh'; \
  echo; \
  echo 'JAVA_HOME=/opt/java/jdk8'; \
} > /etc/profile.d/java_home.sh