FROM ubuntu:16.04

ENV TERM="xterm"

#Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

#Enable universe repo
RUN apt-get update && apt-get -y install lsb-release &&\
    echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe" >> /etc/apt/sources.list &&\
    apt-get update

#Install deb packages
RUN apt-get install -y \
    redis-server \
    redis-tools \
            && \
    apt-get clean all

EXPOSE 6379
CMD /usr/bin/redis-server --port 6369
