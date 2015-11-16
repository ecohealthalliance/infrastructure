FROM ubuntu:15.10

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install haproxy
RUN apt-get update
RUN apt-get -y install haproxy
RUN apt-get clean all

LABEL app="app-router"
EXPOSE 80
EXPOSE 443

# Add config files and scripts
ADD tater.io.pem /tater.io.pem
ADD haproxy.cfg /etc/haproxy/haproxy.cfg
ADD run.sh /run.sh

CMD /bin/bash run.sh
