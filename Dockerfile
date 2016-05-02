# docker build -t g10k/filebeat .
# docker run -v /var/docker/filebeat/conf:/conf -v /var/logs/json_logs:/logs filebeat
FROM telminov/ubuntu-14.04-python-3.5

VOLUME /conf/

RUN apt-get update -qq \
 && apt-get install -qqy curl \
 && apt-get clean

RUN curl -L -O https://download.elastic.co/beats/filebeat/filebeat_1.0.1_amd64.deb \
 && dpkg -i filebeat_1.0.1_amd64.deb \
 && rm filebeat_1.0.1_amd64.deb


ADD filebeat.yml /etc/filebeat/filebeat.yml


CMD test "$(ls /conf/filebeat.yml)" || cp /etc/filebeat/filebeat.yml /conf/filebeat.yml; \
    rm /etc/filebeat/filebeat.yml; ln -s /conf/filebeat.yml /etc/filebeat/filebeat.yml; \
    service filebeat start; \
    sleep 2;\
    tail -f /var/log/filebeat