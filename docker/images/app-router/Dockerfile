FROM ubuntu:16.04

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install haproxy
RUN apt-get update
RUN apt-get -y install haproxy openssh-server less vim supervisor
RUN apt-get clean all

#Setup SSH
ADD supervisor-sshd.conf /etc/supervisor/conf.d/sshd.conf
RUN service ssh start #Need this for 1st time setup
RUN ssh-keygen -b 2048 -f /root/.ssh/id_rsa -N ""
#This is the public key for jenkins
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfnRTZKrsCjf6878ufbnV3Vwg2aDpX2BH7TNGv5xq1m2aZhJ/Kw8tmGmrt3+iTcTYR0eS7hsFkgAotWkkyszkvwEbus/jXUEFAiSNRR61UHP0jV/LndJh0U6R1yqHVndQbfx4pNEr9bi7xMj/4ARs54iGWmH+REMVwMQGrAoEi9CHvPSEGEEhuprvfID3/iDesHtgFz4f1tnzje70pguAIQHBFt3zDjDoeZcSohXDFsJjq1647eyLUy+/wTxzdhpci6rrcOecsKoGnuVYecZOVssRQXlyTeOsD29TIiQceGVp+cqU3AawF2uMF6Er7UP3VSNMwAQhDWyla3NpE3kxt jenkins@jenkins.eha.io" > /root/.ssh/authorized_keys

# Setup haproxy
ADD supervisor-haproxyd.conf /etc/supervisor/conf.d/haproxyd.conf
ADD tater.io.pem /tater.io.pem
ADD haproxy.cfg /etc/haproxy/haproxy.cfg

LABEL app="app-router"
EXPOSE 80
EXPOSE 443
EXPOSE 22

ADD run.sh /run.sh
CMD /bin/bash /run.sh
