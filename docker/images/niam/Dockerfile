FROM ubuntu:16.04

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get install -y supervisor curl build-essential vim git && \
    apt-get clean all

#Install Meteor
RUN curl https://install.meteor.com/ | sh

#Copy necessary repos
COPY nia-monitor /nia-monitor

#Config files
COPY supervisord.conf /etc/supervisor/conf.d/niam.conf

#Build the meteor app
RUN cd /nia-monitor && \
    meteor npm install && \
    meteor lint &&\
    apt-get clean all

EXPOSE 3000


#Create locale settings so meteor mongo works
RUN locale-gen en_US && localedef -i en_US -f UTF-8 en_US
ENV LC_ALL="en_US"

ENV TERM=xterm
CMD supervisord --nodaemon --config /etc/supervisor/supervisord.conf
