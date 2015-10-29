FROM ubuntu:14.04.3

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install haproxy
RUN apt-get -y install haproxy
RUN apt-get clean all

# Only interested in logging haproxy
RUN rm /etc/rsyslog.d/50-default.conf

LABEL app="app-router"
EXPOSE 80
EXPOSE 443

# Add config files and scripts
ADD rsyslog-haproxy /etc/rsyslog.d/49-haproxy.conf
ADD logrotate-haproxy /etc/logrotate.d/haproxy
ADD haproxy.cfg /etc/haproxy/haproxy.cfg
ADD run.sh /run.sh

CMD /bin/bash run.sh
