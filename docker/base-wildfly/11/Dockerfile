FROM bgbilling/base-jdk:8

ENV WILDFLY_VERSION 11.0.0.Final
ENV WILDFLY_SHA1 0e89fe0860a87bfd6b09379ee38d743642edfcfb
ARG WILDFLY_DIR=/opt/wildfly
ENV WILDFLY_HOME=$WILDFLY_DIR/current
ENV JBOSS_HOME=$WILDFLY_HOME

ENV WILDFLY_MEMORY="-Xmx512m"
ENV WILDFLY_DIRECT_MEMORY="-XX:MaxDirectMemorySize=60m"
ENV WILDFLY_META_MEMORY="-XX:MaxMetaspaceSize=200m"

USER root

RUN set -x \
  && [ ! -d $WILDFLY_HOME ] \
  && mkdir -p $WILDFLY_DIR \
  && curl https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz -o /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
  && sha1sum /tmp/wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
  && tar xf /tmp/wildfly-$WILDFLY_VERSION.tar.gz -C $WILDFLY_DIR \
  && ln -s $WILDFLY_DIR/wildfly-$WILDFLY_VERSION $WILDFLY_HOME \
  && rm /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
  && mkdir -p $WILDFLY_HOME/standalone/log \
#  && /usr/sbin/groupadd --system wildfly && /usr/sbin/useradd --system --home-dir $WILDFLY_HOME --gid wildfly --no-create-home wildfly \
#  && chown -R wildfly:wildfly $WILDFLY_DIR/wildfly-$WILDFLY_VERSION \
#  && chown -h wildfly:wildfly $WILDFLY_HOME \
  && chmod -R g+rw $WILDFLY_DIR/wildfly-$WILDFLY_VERSION \
  && ls $WILDFLY_HOME \
  && sed -i 's@-Xmx512m@$WILDFLY_MEMORY $WILDFLY_DIRECT_MEMORY@' $WILDFLY_HOME/bin/standalone.conf \
  && sed -i 's@-XX:MaxMetaspaceSize=256m@$WILDFLY_META_MEMORY@' $WILDFLY_HOME/bin/standalone.conf
  
COPY entrypoint.sh /entrypoint.sh

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

#USER jboss

# Expose the ports we're interested in
EXPOSE 8080

#ENTRYPOINT ["/bin/sh", "entrypoint.sh"]

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/wildfly/current/bin/standalone.sh", "-b", "0.0.0.0"]