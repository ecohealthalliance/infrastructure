FROM ubuntu:16.04

# Install dependencies
# Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get -y install sudo build-essential openssh-server python3 python3-dev python3-setuptools python3-pip python3-software-properties debconf-utils software-properties-common curl libffi-dev libssl-dev acl git make && \
    pip3 install virtualenv virtualenvwrapper awscli && \
    apt-get clean all

RUN pip3 install --upgrade setuptools
RUN pip3 install pycrypto
RUN apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get -y install ansible

# Install mongodb clients
RUN wget -qO - https://www.mongodb.org/static/pgp/server-3.2.asc | sudo apt-key add -
RUN echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-get update && apt-get -y install mongodb-org
RUN apt-get clean all

COPY WITH_SECRET /usr/local/bin/WITH_SECRET
RUN chmod +x /usr/local/bin/WITH_SECRET

COPY promed_mail_scraper /promed_mail_scraper

RUN WITH_SECRET /usr/bin/ansible-playbook --connection=local /promed_mail_scraper/ansible/site.yml --tags preloadable --vault-password-file /.secret --extra-vars "use_secure_aws_credentials=true"

RUN mkdir /shared

ADD cronjob.sh /cronjob.sh

VOLUME /shared
EXPOSE 80
COPY run.sh /run.sh
CMD bash run.sh
