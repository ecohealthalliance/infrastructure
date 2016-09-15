FROM ubuntu:14.04

### Variables ##################################################################################################
ENV TERM="xterm"
ENV GRITS_HOME="/home/grits"
ENV MONGO_URL="mongodb://PLACE.HOLDER:27017"
ENV METEOR_DB_NAME="diagnosis"
ENV PORT="3000"
ENV ROOT_URL="http://change.me"
ENV MAIL_URL="smtp://localhost"
ENV GRID_URL="https://eidr.ecohealthalliance.org"
ENV NLTK_DATA="$GRITS_HOME/nltk_data"
ENV BASIC_AUTH="grits:CHANGEME"

### Need this as a pre-setup ###################################################################################
# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

#Enable universe repo
RUN apt-get update && apt-get -y install lsb-release &&\
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
COPY common/config $GRITS_HOME/grits_config
RUN chown grits:grits $GRITS_HOME/grits_config

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

#Clone/configure grits-api
RUN git clone --depth 1 https://github.com/ecohealthalliance/grits-api.git $GRITS_HOME/grits-api
COPY grits-api/config.py $GRITS_HOME/grits-api/config.py

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
RUN git clone --depth 1 https://github.com/ecohealthalliance/annie.git $GRITS_HOME/annie
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
ENV METEOR_PORT=3000

#Clone diagnostic dashboard repo
RUN git clone --depth 1 https://github.com/ecohealthalliance/diagnostic-dashboard.git $GRITS_HOME/diagnostic-dashboard

#Install meteor
RUN curl https://install.meteor.com | /bin/sh

#Bundle diagnostic-dashboard and install dependencies
RUN cd $GRITS_HOME/diagnostic-dashboard &&\
    meteor bundle --directory bundle &&\
    cd bundle/programs/server &&\
    npm install

#Copy configs
COPY diagnostic-dashboard/config $GRITS_HOME/diagnostic-dashboard/config
COPY diagnostic-dashboard/dashboardd.conf /etc/supervisor/conf.d/dashboardd.conf
COPY diagnostic-dashboard/dashboard.sh /dashboard.sh
COPY diagnostic-dashboard/postfix_main.cf /etc/postfix/main.cf
COPY diagnostic-dashboard/postfix_master.cf /etc/postfix/master.cf
COPY diagnostic-dashboard/postfix_transport /etc/postfix/transport
COPY diagnostic-dashboard/postfix_alias /etc/postfix/virtual_alias
COPY diagnostic-dashboard/postfix_access /etc/postfix/access
COPY diagnostic-dashboard/postfix_gritsmail.sh /etc/postfix/gritsmail.sh
COPY diagnostic-dashboard/parse_email.py /etc/postfix/parse_email.py

#Setup postfix
RUN cat /etc/hostname > /etc/mailname &&\
    postmap /etc/postfix/transport &&\
    postmap /etc/postfix/virtual_alias &&\
    postmap /etc/postfix/access

### ElasticSearch ##################################################################################################
#Configure timezone
RUN echo "America/New_York" > /etc/timezone; dpkg-reconfigure --frontend noninteractive tzdata

#Add repo
RUN add-apt-repository ppa:webupd8team/java && apt-get update

#Accept and install Oracle Java with dependencies
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections; echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections creates=/usr/lib/jvm/java-7-oracle &&\
    apt-get -y install oracle-java7-installer htop ntp unzip

#Create elasticsearch user
RUN groupadd elasticsearch && adduser --no-create-home --disabled-password --ingroup elasticsearch elasticsearch

#Install elasticsearch
RUN curl -O https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.5.deb &&\
    dpkg -i -E --force-confnew elasticsearch-0.90.5.deb

#Configure directories
RUN for dir in "/usr/share/elasticsearch /usr/share/elasticsearch/plugins /var/log/elasticsearch /var/lib/elasticsearch /tmp/elasticsearch /etc/elasticsearch";do \
      mkdir -p $dir && chown -R elasticsearch:elasticsearch $dir; \
    done

#Configure system configs
RUN echo "elasticsearch     -    nofile    65535" >> /etc/security/limits.conf &&\
    echo "elasticsearch     -    memlock   unlimited" >> /etc/security/limits.conf &&\
    echo "session    required   pam_limits.so" >> /etc/pam.d/su &&\
    echo "session    required   pam_limits.so" >> /etc/pam.d/common-session &&\
    echo "session    required   pam_limits.so" >> /etc/pam.d/common-session-noninteractive &&\
    echo "session    required   pam_limits.so" >> /etc/pam.d/sudo

#Copy in config files
COPY elasticsearch/elasticsearch-init.d /etc/init.d/elasticsearch
COPY elasticsearch/elasticsearch.yml /etc/elasticsearch//etc/elasticsearch
COPY elasticsearch/elasticsearch.default /etc/default/elasticsearch

#Install plugins
RUN cd /usr/share/elasticsearch &&\
    bin/plugin -install elasticsearch/elasticsearch-mapper-attachments/2.2.1 &&\
    bin/plugin -install com.github.richardwilly98.elasticsearch/elasticsearch-river-mongodb/2.0.1 &&\
    bin/plugin -install facet-script -url http://dl.bintray.com/content/imotov/elasticsearch-plugins/elasticsearch-facet-script-1.1.2.zip &&\
    chown -R elasticsearch:elasticsearch *
######################################################################################################################

CMD supervisord --nodaemon --config /etc/supervisor/supervisord.conf




