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
RUN git clone https://github.com/ecohealthalliance/nia-monitor.git /nia-monitor

#Build the meteor app
RUN cd /nia-monitor && meteor npm install

EXPOSE 3000

#Create locale settings so meteor mongo works
RUN locale-gen en_US && localedef -i en_US -f UTF-8 en_US
ENV LC_ALL="en_US"
ENV TERM=xterm

RUN mkdir /shared
VOLUME /shared

#Create and use meteor user
RUN groupadd meteor && adduser --ingroup meteor --disabled-password --gecos "" --home /home/meteor meteor
RUN chown -R meteor:meteor /nia-monitor
USER meteor

CMD cd /nia-monitor && git rev-parse HEAD > revision.txt && meteor run --production --settings /shared/meteor-settings.json
