FROM ubuntu:16.04

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get -y install build-essential mongodb supervisor curl && \
    curl https://install.meteor.com/ | sh && \
    apt-get clean all

#Import public keys
COPY public-keys.tar.gz /public-keys.tar.gz
RUN tar -zxf public-keys.tar.gz && \
    for i in $(ls /keys); do gpg --import /keys/$i; done && \
    rm /public-keys.tar.gz && \
    rm -fr /keys

ENV NODE_VERSION=0.10.43

#Install NodeJS
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc

#Config files
COPY supervisord.conf /etc/supervisor/conf.d/niam.conf

#Copy necessary repos
COPY nia-monitor /nia-monitor

#Build the meteor app
#Chaining these commands to keep the image smaller
RUN cd /nia-monitor && \
    (meteor build ./build --directory || exit 1) && \
    cd build/bundle/programs/server && \
    npm install && \
    rm -fr /root/.meteor && \
    apt-get clean all

ENV MONGO_HOST="192.168.99.100"
ENV MONGO_PORT="27017"
ENV MONGO_DB="niam"
ENV MONGO_URI="mongodb://$MONGO_HOST:$MONGO_PORT/$MONGO_DB"
ENV SPARQURL="http://niam.eha.io:3030/dataset/query"
EXPOSE 80
COPY run.sh /run.sh
CMD bash run.sh
