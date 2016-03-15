FROM ubuntu:14.04.3

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get -y install build-essential python python-dev python-setuptools python-pip mongodb-clients mongodb supervisor python-software-properties debconf-utils software-properties-common curl && \
    pip install virtualenv virtualenvwrapper awscli && \
    curl https://install.meteor.com/ | sh && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean all

#Import public keys
COPY public-keys.tar.gz /public-keys.tar.gz
RUN tar -zxf public-keys.tar.gz && \
    for i in $(ls /keys); do gpg --import /keys/$i; done && \
    rm /public-keys.tar.gz && \
    rm -fr /keys

ENV NODE_VERSION=0.12.9

#Install NodeJS
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc

#Add jar file
COPY flirt-legs.jar /flirt-legs.jar

#Config files
COPY mongod-supervisor.conf /etc/supervisor/conf.d/mongod.conf
COPY celery-supervisor.conf /etc/supervisor/conf.d/celery.conf
COPY celery.sh /celery.sh
COPY tornado-supervisor.conf /etc/supervisor/conf.d/tornado.conf
COPY tornado.sh /tornado.sh
COPY flirt-supervisor.conf /etc/supervisor/conf.d/flirt.conf
COPY flirt.sh /flirt.sh

#Copy necessary repos
COPY grits-net-meteor /
RUN mkdir /example/packages
COPY grits-net-meteor /example/packages/grits-net-meteor
COPY grits-net-mapper /example/packages/grits-net-mapper
COPY grits-net-consume /example/packages/grits-net-consume
RUN cp -al /example/packages/grits-net-consume /grits-net-consume
COPY flirt-sidebar /example/packages/flirt-sidebar
COPY flirt-simulation-service /example/packages/flirt-simulation-service
RUN cp -al /example/packages/flirt-simulation-service /flirt-simulation-service

#Build the meteor app
#Chaining these commands to keep the image smaller
RUN cd /example && \
    (meteor build ./gritsbuild --directory || exit 1) && \
    cd /example/gritsbuild/bundle/programs/server && \
    npm install && \
    rm -fr /example/packages && \
    rm -fr /root/.meteor && \
    apt-get clean all

#Setup AWS config
RUN mkdir /root/.aws
ENV AWS_ACCESS_KEY_ID=AKIAJLKTQX7LL2L2JV7Q
ENV AWS_SECRET_ACCESS_KEY=Y9cT3LojWqDFBa+Yh4KvZiKXE/oCVWicbLDgTsNT

#Take care of flirt-simulation-dependencies
RUN bash -c "cd /flirt-simulation-service && \
    virtualenv /flirt-simulation-service-env &&\
    source /flirt-simulation-service-env/bin/activate &&\
    pip install -r requirements.txt"

#Create pypy env
COPY pypy-4.0.1-linux_x86_64-portable.tar.bz2 /pypy-4.0.1-linux_x86_64-portable.tar.bz2
RUN bash -c "tar -xvjf /pypy-4.0.1-linux_x86_64-portable.tar.bz2"
RUN bash -c "virtualenv -p pypy-4.0.1-linux_x86_64-portable/bin/pypy /flirt-pypy-env"
RUN bash -c "cd /flirt-simulation-service/simulator/ && \
    source /flirt-pypy-env/bin/activate &&\
    pip install -r requirements.pip"

ENV FLIRT_SIMULATOR_URL="http://localhost:45000/simulator"
ENV MONGO_HOST="10.0.0.175"
ENV MONGO_PORT="27017"
ENV MONGO_DB="grits-net-meteor"
EXPOSE 80
COPY run.sh /run.sh
CMD bash run.sh

