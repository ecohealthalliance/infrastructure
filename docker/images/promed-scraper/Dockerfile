FROM ubuntu:14.04.4

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get -y install build-essential openssh-server python python-dev python-setuptools python-pip python-software-properties debconf-utils software-properties-common curl libffi-dev libssl-dev acl git make && \
    pip install virtualenv virtualenvwrapper awscli && \
    apt-get clean all

RUN pip install --upgrade setuptools
RUN pip install ansible pycrypto

# Install mongodb clients
# RUN echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe" >> /etc/apt/sources.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-get update && apt-get -y install mongodb-org
RUN apt-get clean all

COPY WITH_SECRET /usr/local/bin/WITH_SECRET
RUN chmod +x /usr/local/bin/WITH_SECRET

COPY promed_mail_scraper /promed_mail_scraper

RUN WITH_SECRET /usr/local/bin/ansible-playbook --connection=local /promed_mail_scraper/ansible/site.yml --tags preloadable --vault-password-file /.secret --extra-vars "use_secure_aws_credentials=true"

RUN mkdir /shared

ADD cronjob.sh /cronjob.sh

VOLUME /shared
EXPOSE 80
COPY run.sh /run.sh
CMD bash run.sh
