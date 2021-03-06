FROM ubuntu:14.04

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get -y install build-essential openssh-server python python-dev python-setuptools python-pip mongodb-clients mongodb supervisor python-software-properties debconf-utils software-properties-common curl libffi-dev libssl-dev git-all && \
    pip install virtualenv virtualenvwrapper awscli && \
    curl https://install.meteor.com/ | sh && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean all

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NODE_VERSION=0.12.9

#Install NodeJS
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc

#Config files
COPY mongod-supervisor.conf /etc/supervisor/conf.d/mongod.conf
COPY spa-supervisor.conf /etc/supervisor/conf.d/spa.conf
COPY spa.sh /spa.sh

#App dir
RUN git clone --depth 1 https://github.com/ecohealthalliance/spa.git /spa-meteor
RUN rm -fr /spa-meteor/packages/flirt-sidebar; git clone --depth 1 https://github.com/ecohealthalliance/flirt-sidebar.git /spa-meteor/packages/flirt-sidebar

RUN mkdir /shared
RUN cp /spa-meteor/settings-development.json /shared/settings-production.json

#submodule requires a submodule and that's not coming through. make sure it's there.
COPY flirt-sidebar /spa-meteor/packages/flirt-sidebar

ENV METEOR_ALLOW_SUPERUSER=true

#Build the meteor app
RUN cd /spa-meteor && \
    git rev-parse HEAD > ../revision.txt && \
    (meteor npm install) && \
    (meteor build ./spabuild --directory || exit 1) && \
    cd /spa-meteor/spabuild/bundle/programs/server && \
    npm install && \
    rm -fr /spa-meteor/packages && \
    rm -fr /root/.meteor && \
    apt-get clean all

VOLUME /shared
EXPOSE 80
COPY run.sh /run.sh
CMD bash run.sh
