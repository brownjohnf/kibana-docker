# Kibana Docker

This Dockerfile builds an all-in-one ELK (Elasticsearch, Kibana, Logstash)
appliance.

# Persistent Data

TODO

# Ports

Elasticsearch is exposed on port 9200.
Kibana is exposed on port 80 via nginx.
Logstash is listening for POSTed HTTP content on 8080.
