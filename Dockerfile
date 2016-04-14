#
# Elasticsearch Dockerfile
#
# https://github.com/dockerfile/elasticsearch
#

# ONLINE SOURCE: https://github.com/nkoterba/elasticsearch/edit/master/Dockerfile

# Pull base image.
FROM dockerfile/java:oracle-java8

ENV ES_PKG_NAME elasticsearch-1.5.0
ENV KIBANA_VERSION 4.5

# Install Elasticsearch.
RUN \
  cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch
  
# Run apt-get update
RUN \
  apt-get update 

# Install vim
RUN \
  apt-get install vim
  
# Install Kibana
RUN \
  echo "deb http://packages.elastic.co/kibana/$KIBANA_VERSION/debian stable main" | tee -a /etc/apt/sources.list && \
  apt-get install kibana

# Install Plugins  
RUN \
  /usr/share/elasticsearch/bin/plugin install delete-by-query && \
  /opt/kibana/bin/kibana plugin --install elastic/sense
  
# Create Tmp directory
RUN \
  mkdir /var/lib/elasticsearch/tmp && \
  chown elasticsearch /var/lib/elasticsearch/tmp
  
RUN \
  echo "cluster.name: snap" >> /etc/elasticsearch/elasticsearch.yml && \
  echo "path.repo: /var/lib/elasticsearch_snapshots/" >> /etc/elasticsearch/elasticsearch.yml && \
  echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml && \
  
# Define mountable directories.
VOLUME ["/data"]

# Mount elasticsearch.yml config
ADD config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["/elasticsearch/bin/elasticsearch && /opt/kibana/bin/kibana"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
#   - 5601: kibana HTTP
EXPOSE 9200
EXPOSE 9300
EXPOSE 5601
