FROM resin/rpi-raspbian:wheezy
MAINTAINER Stefan Biermann <sb@ems-solutions.com> (Updated by Jim Leach)

# Install InfluxDB
ENV INFLUXDB_VERSION 0.11.0-0.rc1
RUN mkdir /tmp
RUN wget https://influxdb.s3.amazonaws.com/influxdb-${INFLUXDB_VERSION}.armhf.deb /tmp/influxdb-${INFLUXDB_VERSION}.armhf.deb
# influxdb-0.11.0-0.rc1.armhf.rpm via https://influxdb.s3.amazonaws.com/influxdb-0.11.0-0.rc1.armhf.rpm
# ADD src/influxdb-${INFLUXDB_VERSION}.armhf.deb /tmp/influxdb-${INFLUXDB_VERSION}.armhf.deb
RUN dpkg -i /tmp/influxdb-${INFLUXDB_VERSION}.armhf.deb && \
  rm /tmp/influxdb-${INFLUXDB_VERSION}.armhf.deb && \
  rm -rf /var/lib/apt/lists/*

ADD src/config.toml /config/config.toml
ADD src/run.sh /run.sh
RUN chmod +x /*.sh

ENV PRE_CREATE_DB **None**
ENV SSL_SUPPORT **False**
ENV SSL_CERT **None**

# Admin server
EXPOSE 8083

# HTTP API
EXPOSE 8086

# Raft port (for clustering, don't expose publicly!)
#EXPOSE 8090

# Protobuf port (for clustering, don't expose publicly!)
#EXPOSE 8099

VOLUME ["/data"]

CMD ["/run.sh"]
