FROM ubuntu:14.04.4

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get -y install build-essential python python-dev python-setuptools python-pip mongodb-clients mongodb supervisor python-software-properties debconf-utils software-properties-common curl software-properties-common git && \
    pip install virtualenv virtualenvwrapper awscli && \
    curl https://install.meteor.com/ | sh && \
    add-apt-repository ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get -y install openjdk-8-jdk && \
    apt-get clean all

#Import public keys
COPY public-keys.tar.gz /public-keys.tar.gz
RUN tar -zxf public-keys.tar.gz && \
    for i in $(ls /keys); do gpg --import /keys/$i; done && \
    rm /public-keys.tar.gz && \
    rm -fr /keys

ENV NODE_VERSION=0.12.9

#Install NodeJS
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc

#Add jar file
COPY flirt-legs.jar /flirt-legs.jar

#Config files
COPY mongod-supervisor.conf /etc/supervisor/conf.d/mongod.conf
COPY celery-supervisor.conf /etc/supervisor/conf.d/celery.conf
COPY celery.sh /celery.sh
COPY tornado-supervisor.conf /etc/supervisor/conf.d/tornado.conf
COPY tornado.sh /tornado.sh
COPY flirt-supervisor.conf /etc/supervisor/conf.d/flirt.conf
COPY flirt.sh /flirt.sh

#Copy necessary repos
RUN git clone --depth 1 https://github.com/ecohealthalliance/flirt.git /flirt-webapp
RUN git clone --depth 1 https://github.com/ecohealthalliance/flirt-simulation-service.git /flirt-simulation-service
RUN git clone --depth 1 https://github.com/ecohealthalliance/grits-net-consume.git /grits-net-consume

ENV METEOR_ALLOW_SUPERUSER=true

#Build the meteor app
#Chaining these commands to keep the image smaller
RUN cd /flirt-webapp/app && \
    git rev-parse HEAD > revision.txt && \ 
    (meteor build ./build --directory || exit 1) && \
    cd /flirt-webapp/app/build/bundle/programs/server && \
    npm install && \
    rm -fr /root/.meteor && \
    apt-get clean all

#Setup AWS config
RUN mkdir /root/.aws

#Take care of flirt-simulation-dependencies
RUN bash -c "cd /flirt-simulation-service &&\
    virtualenv /flirt-simulation-service-env &&\
    source /flirt-simulation-service-env/bin/activate &&\
    pip install -r requirements.txt  &&\
    cd /flirt-simulation-service/simulator/ &&\
    pip install -r requirements.pip"

ENV FLIRT_SIMULATOR_URL="http://localhost:45000/simulator"
ENV MONGO_HOST="localhost"
ENV MONGO_PORT="27017"
ENV MONGO_DB="flirt"
ENV MONGO_URI="mongodb://$MONGO_HOST:$MONGO_PORT/$MONGO_DB"
EXPOSE 80
CMD service supervisor start
