FROM bgbilling/base-jdk:8

ENV ACTIVEMQ_VERSION 5.15.4
ENV ACTIVEMQ=apache-activemq-$ACTIVEMQ_VERSION
ENV ACTIVEMQ_HOME /opt/activemq/current

ARG ACTIVEMQ_URL=https://archive.apache.org/dist/activemq/$ACTIVEMQ_VERSION/$ACTIVEMQ-bin.tar.gz
ARG ACTIVEMQ_SHA512=26d8154fcfe17ab90508b3b9d46b40815404fa3886cfdc4eae4b06086332203bd2455475b9309ccabd76d0c9b65f523f9d3911d315c17bf4b48bd22395ea8ead

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