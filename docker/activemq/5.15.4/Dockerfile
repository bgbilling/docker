FROM bgbilling/base-jdk:8

ENV ACTIVEMQ_VERSION 5.15.4
ENV ACTIVEMQ=apache-activemq-$ACTIVEMQ_VERSION
ENV ACTIVEMQ_HOME /opt/activemq/current

ACTIVEMQ_URL=https://archive.apache.org/dist/activemq/$ACTIVEMQ_VERSION/$ACTIVEMQ-bin.tar.gz
ACTIVEMQ_SHA512=450469a36147cef8dc3ef5f98de7e173dc63e5ca82e090417c112a70132b7a7da87851e330443e9d68f085c375f4e85f2cae34317d09a59295fec05dab8f2d26

RUN set -x \
  && [ ! -f /opt/activemq ] \
  && mkdir -p /opt/activemq \
  && curl $ACTIVEMQ_URL -o /tmp/$ACTIVEMQ-bin.tar.gz \
  && sha512sum /tmp/$ACTIVEMQ-bin.tar.gz | grep $ACTIVEMQ_SHA512 \
  && tar xzf /tmp/$ACTIVEMQ-bin.tar.gz -C /opt/activemq \
  && ln -s /opt/activemq/$ACTIVEMQ $ACTIVEMQ_HOME \
  && rm $ACTIVEMQ_HOME/conf/activemq.xml \
  && curl https://raw.githubusercontent.com/bgbilling/images-base/master/install/activemq/activemq.xml -o $ACTIVEMQ_HOME/conf/activemq.xml \
#  && addgroup --system activemq && adduser --system --home $ACTIVEMQ_HOME --no-create-home --disabled-login --group activemq \
#  && chown -R activemq:activemq /opt/activemq/$ACTIVEMQ \
#  && chown -h activemq:activemq $ACTIVEMQ_HOME \
  && rm /tmp/$ACTIVEMQ-bin.tar.gz \
  && rm $ACTIVEMQ_HOME/activemq-all-$ACTIVEMQ_VERSION.jar \
  && rm -rf /var/cache/apk/* \
  && rm -fr /tmp/* /var/tmp/*

WORKDIR $ACTIVEMQ_HOME

COPY activemq.xml $ACTIVEMQ_HOME/conf/

COPY entrypoint.sh /entrypoint.sh

EXPOSE 61616 5672 8161

HEALTHCHECK --start-period=3m --interval=30s --timeout=20s --retries=10 \
  CMD curl -f http://localhost:8161/ || exit 1

#ENTRYPOINT ["/bin/sh", "entrypoint.sh"]

CMD ["/bin/sh", "-c", "bin/activemq console"]