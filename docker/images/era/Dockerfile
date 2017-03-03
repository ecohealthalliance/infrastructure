FROM ubuntu:16.04

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get install -y supervisor curl build-essential git && \
    apt-get clean all

#Install Meteor
RUN curl https://install.meteor.com/ | sh

#Config files
COPY era-supervisor.conf /etc/supervisor/conf.d/era.conf
COPY era.sh /era.sh

#make app dirs
RUN mkdir /shared 
COPY era /era-webapp

#Create and use meteor user
RUN groupadd meteor && adduser --ingroup meteor --disabled-password --gecos "" --home /home/meteor meteor
RUN chown -R meteor:meteor /era-webapp
USER meteor

#Build the meteor app
RUN cd /era-webapp && \
    (meteor build ./build --directory || exit 1)
RUN cd /era-webapp/build/bundle/programs/server && \
    meteor npm install && \
    rm -fr /era-webapp/packages
RUN cd /era-webapp/build/bundle/programs/server && \
    apt-get clean all

VOLUME /shared
EXPOSE 80
CMD supervisord --nodaemon --config /etc/supervisor/supervisord.conf

