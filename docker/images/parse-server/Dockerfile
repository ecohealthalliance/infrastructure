FROM ubuntu:16.04

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get install -y supervisor curl build-essential nodejs npm git nodejs-legacy && \
    apt-get clean all

#Install parse server
RUN npm install -g parse-server mongodb-runner parse-dashboard

COPY supervisor-server.conf /etc/supervisor/conf.d/server.conf
COPY parse-server.sh /parse-server.sh
COPY supervisor-dashboard.conf /etc/supervisor/conf.d/dashboard.conf
COPY parse-dashboard.sh /parse-dashboard.sh

EXPOSE 80
EXPOSE 4040
EXPOSE 1337
CMD supervisord --nodaemon --config /etc/supervisor/supervisord.conf
