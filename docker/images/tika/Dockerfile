FROM ubuntu:14.04.3

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install deb dependencies
RUN echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install openjdk-7-jre wget
RUN apt-get clean all

RUN wget http://mirror.cc.columbia.edu/pub/software/apache/tika/tika-server-1.11.jar

LABEL app="tika"
EXPOSE 9998

ADD run.sh /run.sh
CMD /bin/bash run.sh
