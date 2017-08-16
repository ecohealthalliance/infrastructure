FROM ubuntu:16.04

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install haproxy
RUN apt-get update
RUN apt-get -y install haproxy less vim supervisor
RUN apt-get clean all

# Setup haproxy
ADD supervisor-haproxyd.conf /etc/supervisor/conf.d/haproxyd.conf
ADD haproxy.cfg /etc/haproxy/haproxy.cfg

LABEL app="app-router"
EXPOSE 80
EXPOSE 443
VOLUME /etc/letsencrypt
ADD run.sh /run.sh
CMD /bin/bash /run.sh
