#!/bin/sh -eux

WILDFLY_VERSION=11.0.0.Final
WILDFLY_SHA1=0e89fe0860a87bfd6b09379ee38d743642edfcfb
WILDFLY_DIR=/opt/wildfly2
WILDFLY_HOME=$WILDFLY_DIR/current
JBOSS_HOME=$WILDFLY_HOME

WILDFLY_MEMORY="-Xmx512m"
WILDFLY_DIRECT_MEMORY="-XX:MaxDirectMemorySize=60m"
WILDFLY_META_MEMORY="-XX:MaxMetaspaceSize=200m"

[ ! -d $WILDFLY_HOME ] \
  && mkdir -p $WILDFLY_DIR \
  && curl https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz -o /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
  && sha1sum /tmp/wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
  && tar xf /tmp/wildfly-$WILDFLY_VERSION.tar.gz -C $WILDFLY_DIR \
  && ln -s $WILDFLY_DIR/wildfly-$WILDFLY_VERSION $WILDFLY_HOME \
  && rm /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
  && mkdir -p $JBOSS_HOME/standalone/log \
  && addgroup --system wildfly && adduser --system --home $WILDFLY_HOME --no-create-home --disabled-login wildfly && adduser wildfly wildfly \
  && chown -R wildfly:wildfly ${WILDFLY_DIR} \
  && chmod -R g+rw ${WILDFLY_DIR} \
  && ls $JBOSS_HOME \
  && sed -i 's@-Xmx512m@$WILDFLY_MEMORY $WILDFLY_DIRECT_MEMORY@' $JBOSS_HOME/bin/standalone.conf \
  && sed -i 's@-XX:MaxMetaspaceSize=256m@$WILDFLY_META_MEMORY@' $JBOSS_HOME/bin/standalone.conf