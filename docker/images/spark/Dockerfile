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
            vim \
            wget \
            openjdk-9-jre \
            less \
            python \
            python-pip \
            scala \
            && \
    apt-get clean all

#Get spark
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.1-bin-hadoop2.7.tgz &&\
    tar -zxf spark-2.0.1-bin-hadoop2.7.tgz &&\
    rm spark-2.0.1-bin-hadoop2.7.tgz

EXPOSE 7077
EXPOSE 8080
EXPOSE 8081

CMD /spark-2.0.1-bin-hadoop2.7/sbin/start-master.sh && sleep infinity
