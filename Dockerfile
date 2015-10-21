FROM    library/java:openjdk-8-jre

WORKDIR /src

RUN     apt-get update -y && apt-get install -y \
          supervisor \
          nginx

ENV     ELASTICSEARCH elasticsearch-2.0.0-rc1
ENV     KIBANA kibana-4.2.0-beta2-linux-x64
ENV     LOGSTASH logstash-1.5.4

COPY    $ELASTICSEARCH.tar.gz $ELASTICSEARCH.tar.gz
COPY    $KIBANA.tar.gz $KIBANA.tar.gz
COPY    $LOGSTASH.tar.gz $LOGSTASH.tar.gz

RUN     tar -xzf $ELASTICSEARCH.tar.gz && \
        tar -xzf $KIBANA.tar.gz && \
        tar -xzf $LOGSTASH.tar.gz && \
        mv $ELASTICSEARCH elasticsearch && \
        mv $KIBANA kibana && \
        mv $LOGSTASH logstash && \
        ./logstash/bin/plugin install logstash-input-http

COPY    default-site /etc/nginx/sites-available/default
COPY    htpasswd /etc/nginx/htpasswd.users
COPY    supervisord.conf supervisord.conf
COPY    logstash-simple.conf logstash-simple.conf

RUN     mkdir tmp && \
        mkdir log && \
        useradd elasticsearch && \
        chown -R elasticsearch: /src/elasticsearch

        # Kibana via Nginx
EXPOSE  80
        # Logstash HTTP listener
EXPOSE  8080
        # Raw Elasticsearch
EXPOSE  9200

CMD     supervisord -c supervisord.conf
