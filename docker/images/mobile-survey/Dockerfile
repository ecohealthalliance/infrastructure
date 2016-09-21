FROM ubuntu:16.04

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get install -y supervisor curl build-essential vim nodejs nodejs-legacy npm git && \
    apt-get clean all
 
#Install Meteor
RUN curl https://install.meteor.com/ | sh

#Config files
COPY supervisor-mobile-survey.conf /etc/supervisor/conf.d/mobile-survey.conf
COPY mobile-survey.sh /mobile-survey.sh

#make app dirs
RUN mkdir /shared &&\
    git clone https://github.com/ecohealthalliance/mobile-survey.git /mobile-survey-webapp

#This is a giant hack to get around dependency hell
#RUN rm -fr /mobile-survey-webapp/app/packages/parse/.npm /mobile-survey-webapp/app/packages/fibers/.npm /mobile-survey-webapp/app/packages/npm-bcrypt/.npm
RUN rm -fr /mobile-survey-webapp/app/packages/*/.npm

#Build the meteor app
RUN cd /mobile-survey-webapp/app && \
    npm install && \
    apt-get clean all

VOLUME /shared
EXPOSE 80
ENV TERM=xterm
CMD supervisord --nodaemon --config /etc/supervisor/supervisord.conf

