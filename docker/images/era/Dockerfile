FROM ubuntu:16.04

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get install -y supervisor curl build-essential nodejs npm git nodejs-legacy && \
    apt-get clean all

#Install Meteor
RUN curl https://install.meteor.com/ | sh

#Config files
COPY era-supervisor.conf /etc/supervisor/conf.d/era.conf
COPY era.sh /era.sh

#make app dirs
RUN mkdir /shared 
COPY era/sample-settings.json /shared/settings-production.json
COPY era /era-webapp

#Build the meteor app
RUN cd /era-webapp && \
    (meteor build ./build --directory || exit 1) && \
    cd /era-webapp/build/bundle/programs/server && \
    npm install && \
    rm -fr /era-webapp/packages && \
    rm -fr /root/.meteor && \
    apt-get clean all

VOLUME /shared
EXPOSE 80
CMD supervisord --nodaemon --config /etc/supervisor/supervisord.conf

