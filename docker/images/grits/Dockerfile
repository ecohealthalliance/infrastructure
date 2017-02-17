FROM ubuntu:14.04

# There are config files EVERYWHERE. All of the proceeding work with vars is an attempt to tame that by
# creating a single source-vars.sh file where ALL configs can be found and changed. This greatly
# complicates the build process, but makes life easier of anyone having to administer/import this image

### Variables ##################################################################################################
ENV TERM="xterm"
ENV GRITS_HOME="/home/grits"
ENV MONGO_URL="mongodb://CHANGEME:27017"
ENV METEOR_DB_NAME="diagnosis"
ENV PORT="3001"
ENV ROOT_URL="http://CHANGEME"
ENV MAIL_URL="smtp://localhost"
ENV GRID_URL="https://eidr.ecohealthalliance.org"
ENV NLTK_DATA="$GRITS_HOME/nltk_data"
ENV ANNOTATOR_DB_PATH="/shared/.annotator.sqlitedb"
ENV BASIC_AUTH="CHANGEME"
ENV GEONAME_LOOKUP_URL="http://geoname-lookup.eha.io/"

#Environment variables do not get exported to all subshells.
#Have to take this brute force approach
RUN touch /source-vars.sh &&\
    chmod +x /source-vars.sh &&\
    echo "export GRITS_HOME=$GRITS_HOME" >> /source-vars.sh &&\
    echo "export MONGO_URL=$MONGO_URL" >> /source-vars.sh &&\
    echo "export METEOR_DB_NAME=$METEOR_DB_NAME" >> /source-vars.sh &&\
    echo "export PORT=$PORT" >> /source-vars.sh &&\
    echo "export ROOT_URL=$ROOT_URL" >> /source-vars.sh &&\
    echo "export MAIL_URL=$MAIL_URL" >> /source-vars.sh &&\
    echo "export GRID_URL=$GRID_URL" >> /source-vars.sh &&\
    echo "export NLTK_DATA=$NLTK_DATA" >> /source-vars.sh &&\
    echo "export BASIC_AUTH=$BASIC_AUTH" >> /source-vars.sh &&\
    echo "export AWS_ACCESS_KEY_ID=CHANGEME" >> /source-vars.sh &&\
    echo "export AWS_SECRET_ACCESS_KEY=CHANGEME" >> /source-vars.sh &&\
    echo "export AWS_DEFAULT_REGION=us-east-1" >> /source-vars.sh &&\
    echo "export BROKER_URL=redis://CHANGEME:6379/0" >> /source-vars.sh &&\
    echo "export BING_TRANSLATE_ID=CHANGEME" >> /source-vars.sh &&\
    echo "export BING_TRANSLATE_SECRET=CHANGEME" >> /source-vars.sh &&\
    echo "export GRITS_API_KEY=CHANGEME" >> /source-vars.sh &&\
    echo "export BSVE_ENDPOINT=http://beta-search.bsvecosystem.net" >> /source-vars.sh &&\
    echo "export BSVE_USER_NAME=CHANGEME" >> /source-vars.sh &&\
    echo "export BSVE_API_KEY=CHANGEME" >> /source-vars.sh &&\
    echo "export BSVE_SECRET_KEY=CHANGEME" >> /source-vars.sh &&\
    echo "export BSVE_ACCESS_KEY=loremipsumhello714902" >> /source-vars.sh &&\
    echo "export GRITS_CURATOR_EMAIL=CHANGEME" >> /source-vars.sh &&\
    echo "export GRITS_CURATOR_PASSWORD=CHANGEME" >> /source-vars.sh

### Need this as a pre-setup ###################################################################################
# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

#Enable universe repo
RUN apt-get update && apt-get -y install lsb-release wget &&\
    echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe" >> /etc/apt/sources.list &&\
    apt-get update

#Enable node related PPA
RUN apt-get install -y software-properties-common &&\
    add-apt-repository ppa:chris-lea/node.js &&\
    apt-get update

### Dependencies ###############################################################################################
#Sensitive settings will go here
VOLUME /shared

#Install deb packages
RUN apt-get install -y \
        vim \
        supervisor \
        curl \
        build-essential \
        git \
        python-pip \
        python-dev \
        cron \
        postfix \
        apache2 \
        nodejs \
        g++ \
        make \
        gfortran \
        libopenblas-dev \
        liblapack-dev \
        lib32z1-dev \
        zip \
        unzip \
        libxml2-dev \
        libxslt1-dev \
        libjpeg-dev \
        default-jre \
        default-jdk \
        tomcat7 \
        python-software-properties \
    && \
    apt-get clean all

#Install pip packages
RUN pip install \
        awscli \
        virtualenv

#Create grits user and group
RUN groupadd grits && adduser --ingroup grits --home $GRITS_HOME grits

#Grits environment configuration
RUN cd $GRITS_HOME &&\
    touch grits_config &&\
    chown grits:grits grits_config &&\
    echo "export CLASSIFIER_DATA_ACCESS_KEY=$CLASSIFIER_DATA_ACCESS_KEY" >> grits_config &&\
    echo "export CLASSIFIER_DATA_SECRET_KEY=$CLASSIFIER_DATA_SECRET_KEY" >> grits_config &&\
    echo "export GIRDER_DATA_ACCESS_KEY=$GIRDER_DATA_ACCESS_KEY" >> grits_config &&\
    echo "export GIRDER_DATA_SECRET_KEY=GIRDER_DATA_SECRET_KEY" >> grits_config &&\
    echo "export MONGO_URL=$MONGO_URL" >> grits_config &&\
    echo "export CELERY_BROKER=$BROKER_URL" >> grits_config &&\
    echo "export APACHE_URL=$ROOT_URL" >> grits_config &&\
    echo "export GIRDER_MOUNT_PATH=$GIRDER_MOUNT_PATH" >> grits_config &&\
    echo "export GIRDER_ADMIN_PASSWORD=$GIRDER_ADMIN_PASSWORD" >> grits_config &&\
    echo "export GIRDER_ADMIN_EMAIL=$GIRDER_ADMIN_EMAIL" >> grits_config &&\
    echo "# Be careful to use different dump directories for production and development" >> grits_config &&\
    echo "export BING_TRANSLATE_ID=$BING_TRANSLATE_ID" >> grits_config &&\
    echo "export BING_TRANSLATE_SECRET=$BING_TRANSLATE_SECRET" >> grits_config &&\
    echo "export METEOR_DB_NAME=$METEOR_DB_NAME" >> grits_config &&\
    echo "export METEOR_MONGO=$MONGO_URL/$METEOR_DB_NAME" >> grits_config &&\
    echo "export METEOR_PORT=$PORT" >> grits_config

#Cron
RUN mkdir $GRITS_HOME/cron $GRITS_HOME/cron/logs &&\
    chown -R grits:grits $GRITS_HOME/cron

#Postfix
COPY postfix/postfix.conf /etc/supervisor/conf.d/postfix.conf

#Apache
RUN a2enmod proxy &&\
    a2enmod proxy_http &&\
    a2enmod rewrite &&\
    a2enmod ssl &&\
    a2enmod proxy_wstunnel

COPY apache/ports.conf /etc/apache2/ports.conf
COPY apache/proxy.conf /etc/apache2/conf-enabled/proxy.conf
COPY apache/ssl.conf /etc/apache2/mods-enabled/ssl.conf
COPY apache/supervisor-apached.conf /etc/supervisor/conf.d/apached.conf

### Grits-API ###################################################################################################
USER grits
RUN git clone --depth 1 https://github.com/ecohealthalliance/grits-api.git $GRITS_HOME/grits-api

#Configure grits-api
RUN cd $GRITS_HOME/grits-api &&\
    touch config.py &&\
    chown grits:grits config.py &&\
    echo "aws_access_key = '$AWS_ACCESS_KEY_ID'" >> config.py &&\
    echo "aws_secret_key = '$AWS_SECRET_ACCESS_KEY'" >> config.py &&\
    echo "BROKER_URL = '$BROKER_URL'" >> config.py &&\
    echo "mongo_url = '$MONGO_URL'" >> config.py &&\
    echo "bing_translate_id = '$BING_TRANSLATE_ID'" >> config.py &&\
    echo "bing_translate_secret = '$BING_TRANSLATE_SECRET'" >> config.py &&\
    echo "api_key = '$GRITS_API_KEY'" >> config.py &&\
    echo "# The grits histogram app communicates with the bsve api by proxying through the grits api." >> config.py &&\
    echo "# The BSVE api key, username, etc. here are used for authentication." >> config.py &&\
    echo "bsve_endpoint = '$BSVE_ENDPOINT'" >> config.py &&\
    echo "bsve_user_name = '$BSVE_USER_NAME'" >> config.py &&\
    echo "bsve_api_key = '$BSVE_API_KEY'" >> config.py &&\
    echo "bsve_secret_key = '$BSVE_SECRET_KEY'" >> config.py &&\
    echo "grits_curator_email = '$GRITS_CURATOR_EMAIL'" >> config.py &&\
    echo "grits_curator_password = '$GRITS_CURATOR_PASSWORD'" >> config.py

#Install pip modules into virtenv
RUN cd $GRITS_HOME &&\
    virtualenv grits_env &&\
    source grits_env/bin/activate &&\
    pip install setuptools==9.1 &&\
    pip install numpy nose &&\
    cd grits-api &&\
    pip install -r requirements.txt

#Download nltk data
RUN cd $GRITS_HOME &&\
    source grits_env/bin/activate &&\
    ITEMS="maxent_ne_chunker maxent_treebank_pos_tagger words punkt"; \
    for item in $ITEMS;do \
      grits_env/bin/python -c "import nltk; nltk.download('$item')" && echo done > ".nltk_${item}_downloaded" ; \
    done

#Clone/install annie
RUN git clone https://github.com/ecohealthalliance/annie.git $GRITS_HOME/annie
RUN cd $GRITS_HOME/annie && $GRITS_HOME/grits_env/bin/python setup.py install

#Config files
COPY grits-api/celeryd.conf /etc/supervisor/conf.d/celeryd.conf
COPY grits-api/celery_priority.sh /celery_priority.sh
COPY grits-api/celery_process.sh /celery_process.sh
COPY grits-api/celery_diagnose.sh /celery_diagnose.sh
COPY grits-api/gritsapid.conf /etc/supervisor/conf.d/gritsapid.conf
COPY grits-api/gritsapi.sh /gritsapi.sh
COPY grits-api/flowerd.conf /etc/supervisor/conf.d/flowerd.conf
COPY grits-api/flower.sh /flower.sh
COPY grits-api/diagnose_girder_HM_articles $GRITS_HOME/cron/diagnose_girder_HM_articles

USER root

#Install meteor
RUN curl https://install.meteor.com | /bin/sh

### JVM-NLP ######################################################################################################
#Copy in config files
COPY jvm-nlp/tomcat7 /etc/default/tomcat7
COPY jvm-nlp/tomcatd.conf /etc/supervisor/conf.d/tomcatd.conf

#Clone repo and run sbt package
RUN git clone --depth 1 https://github.com/ecohealthalliance/jvm-nlp.git $GRITS_HOME/jvm-nlp
RUN cd $GRITS_HOME/jvm-nlp/ && ./sbt package && echo done > .sbt_package_done

#Deploy scala webapp
RUN rm -rf /var/lib/tomcat7/webapps/ROOT* &&\
    cp $GRITS_HOME/jvm-nlp/target/scala-2.11/*.war /var/lib/tomcat7/webapps/ROOT.war

### Diagnostic-Dashboard ##########################################################################################
ENV DOMAIN=eha.io
USER grits

#Clone diagnostic dashboard repo
RUN git clone https://github.com/ecohealthalliance/diagnostic-dashboard.git $GRITS_HOME/diagnostic-dashboard && cd $GRITS_HOME/diagnostic-dashboard && git reset --hard ffca276224434866f3de21bb3caa2ad64c387d9c


#Bundle diagnostic-dashboard and install dependencies
RUN cd $GRITS_HOME/diagnostic-dashboard &&\
    git rev-parse HEAD > revision.txt &&\
    meteor bundle --directory bundle &&\
    cd bundle/programs/server &&\
    npm install

#Copy configs
USER root
COPY diagnostic-dashboard/dashboardd.conf /etc/supervisor/conf.d/dashboardd.conf
COPY diagnostic-dashboard/dashboard.sh /dashboard.sh
COPY diagnostic-dashboard/postfix_main.cf /etc/postfix/main.cf
COPY diagnostic-dashboard/postfix_master.cf /etc/postfix/master.cf
COPY diagnostic-dashboard/postfix_transport /etc/postfix/transport
COPY diagnostic-dashboard/postfix_alias /etc/postfix/virtual_alias
COPY diagnostic-dashboard/postfix_access /etc/postfix/access
COPY diagnostic-dashboard/postfix_gritsmail.sh /etc/postfix/gritsmail.sh
COPY diagnostic-dashboard/parse_email.py /etc/postfix/parse_email.py

#Generate config file
RUN cd $GRITS_HOME/diagnostic-dashboard &&\
    touch config &&\
    echo "export PORT=$PORT" >> config &&\
    echo "export MONGO_URL=$MONGO_URL/$METEOR_DB_NAME" >> config &&\
    echo "export ROOT_URL=$ROOT_URL" >> config &&\
    echo "export MAIL_URL=$MAIL_URL" >> config

#Setup postfix
RUN cat /etc/hostname > /etc/mailname &&\
    postmap /etc/postfix/transport &&\
    postmap /etc/postfix/virtual_alias &&\
    postmap /etc/postfix/access

######################################################################################################################
#Bundle classifier data
RUN mkdir $GRITS_HOME/classifiers/ &&\
    aws --no-sign-request s3 sync s3://classifier-data/classifiers/ $GRITS_HOME/classifiers/ &&\
    export CLASSIFIER_PATH=$(ls -t $GRITS_HOME/classifiers/*/*.p | head -1 | xargs dirname) &&\
    ln -s $CLASSIFIER_PATH $GRITS_HOME/grits-api/current_classifier

######################################################################################################################

COPY logging/logging.sh /logging.sh
COPY logging/supervisor-logging.conf /etc/supervisor/conf.d/supervisor-logging.conf
COPY scripts /scripts
VOLUME /etc/letsencrypt
#VOLUME /home/grits
COPY run.sh /run.sh
CMD bash run.sh
