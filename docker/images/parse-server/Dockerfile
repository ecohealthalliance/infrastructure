FROM ubuntu:16.04

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get install -y supervisor curl build-essential nodejs npm git nodejs-legacy && \
    apt-get clean all

#Install moving parts for parse server
#RUN npm install -g mongodb-runner parse-dashboard
RUN git clone https://github.com/ecohealthalliance/gq-parse-server.git /gq-parse-server
RUN cd /gq-parse-server && npm install

COPY supervisor-server.conf /etc/supervisor/conf.d/server.conf
#COPY supervisor-dashboard.conf /etc/supervisor/conf.d/dashboard.conf
COPY parse-dashboard.sh /parse-dashboard.sh
COPY parse-dashboard-config.json /parse-dashboard-config.json
COPY parse-server.sh /parse-server.sh

#Settings file is located on a shared volume on server
RUN ln -s /shared/parse-server-config.json /gq-parse-server/settings.json

EXPOSE 80
EXPOSE 4040
EXPOSE 1337
ENV TERM=xterm
CMD supervisord --nodaemon --config /etc/supervisor/supervisord.conf
