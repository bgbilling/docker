#!/bin/sh -eux

WILDFLY_VERSION=11.0.0.Final
WILDFLY_SHA1=0e89fe0860a87bfd6b09379ee38d743642edfcfb
WILDFLY_DIR=/opt/wildfly
WILDFLY_HOME=$WILDFLY_DIR/current
JBOSS_HOME=$WILDFLY_HOME

WILDFLY_MEMORY="-Xmx512m"
WILDFLY_DIRECT_MEMORY="-XX:MaxDirectMemorySize=60m"
WILDFLY_META_MEMORY="-XX:MaxMetaspaceSize=200m"

set -x \
  && [ ! -d $WILDFLY_HOME ] \
  && mkdir -p $WILDFLY_DIR \
  && curl https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz -o /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
  && sha1sum /tmp/wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
  && tar xf /tmp/wildfly-$WILDFLY_VERSION.tar.gz -C $WILDFLY_DIR \
  && ln -s $WILDFLY_DIR/wildfly-$WILDFLY_VERSION $WILDFLY_HOME \
  && rm /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
  && mkdir -p $WILDFLY_HOME/standalone/log \
  && /usr/sbin/groupadd --system wildfly && /usr/sbin/useradd --system --home-dir $WILDFLY_HOME --gid wildfly --no-create-home wildfly \
  && chown -R wildfly:wildfly $WILDFLY_DIR/wildfly-$WILDFLY_VERSION \
  && chown -h wildfly:wildfly $WILDFLY_HOME \
  && chmod -R g+rw $WILDFLY_DIR/wildfly-$WILDFLY_VERSION \
  && ls $WILDFLY_HOME \
  && sed -i 's@-Xmx512m@$WILDFLY_MEMORY $WILDFLY_DIRECT_MEMORY@' $WILDFLY_HOME/bin/standalone.conf \
  && sed -i 's@-XX:MaxMetaspaceSize=256m@$WILDFLY_META_MEMORY@' $WILDFLY_HOME/bin/standalone.conf \
  && curl https://raw.githubusercontent.com/bgbilling/images-base/master/install/wildfly/wildfly.service -o /lib/systemd/system/wildfly.service