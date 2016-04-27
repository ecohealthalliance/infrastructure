FROM ubuntu:16.04

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get install -y supervisor curl build-essential nodejs npm git nodejs-legacy && \
    apt-get clean all

#Install parse server
RUN npm install -g parse-server mongodb-runner

EXPOSE 80
COPY parse-server.sh /parse-server.sh
CMD /bin/bash /parse-server.sh

