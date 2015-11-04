FROM ubuntu:14.04.3

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install lighttpd
RUN echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install lighttpd
RUN apt-get clean all

#Add config and file
ADD index.html /var/www/index.html
ADD run.sh /run.sh

LABEL app="healthcheck"
EXPOSE 80

CMD /bin/bash run.sh
