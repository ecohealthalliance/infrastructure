FROM ubuntu:14.04.4

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get install -y supervisor curl build-essential && \
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


#Install Meteor
RUN curl https://install.meteor.com/ | sh

#Config files
COPY era-supervisor.conf /etc/supervisor/conf.d/era.conf
COPY era.sh /era.sh

#make app dirs
RUN mkdir /shared 
COPY era/sample-settings.json /shared/settings-production.json
COPY era /era-webapp

#Build the meteor app
RUN cd /era-webapp && \
    (meteor build ./build --directory || exit 1) && \
    cd /era-webapp/build/bundle/programs/server && \
    npm install && \
    rm -fr /era-webapp/packages && \
    rm -fr /root/.meteor && \
    apt-get clean all

VOLUME /shared
EXPOSE 80
CMD supervisord --nodaemon --config /etc/supervisor/supervisord.conf
