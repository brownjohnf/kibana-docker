FROM    library/java:openjdk-8-jre

WORKDIR /src

RUN     apt-get update -y && apt-get install -y \
          supervisor \
          nginx

ENV     ELASTICSEARCH elasticsearch-2.0.0-rc1
ENV     KIBANA kibana-4.2.0-beta2-linux-x64
ENV     LOGSTASH logstash-1.5.4

COPY    . .

RUN     tar -xzf $ELASTICSEARCH.tar.gz && \
        tar -xzf $KIBANA.tar.gz && \
        tar -xzf $LOGSTASH.tar.gz && \
        mv $ELASTICSEARCH elasticsearch && \
        mv $KIBANA kibana && \
        mv $LOGSTASH logstash && \
        mv nginx.conf /etc/nginx/sites-available/default && \
        mv htpasswd /etc/nginx/htpasswd.users && \
        mkdir tmp && mkdir log && \
        useradd elasticsearch && \
        chown -R elasticsearch: /src/elasticsearch

EXPOSE  80
EXPOSE  9200

CMD     supervisord -c supervisord.conf
