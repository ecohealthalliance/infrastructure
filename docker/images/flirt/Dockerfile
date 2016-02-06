FROM node:0.12

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get -y install build-essential python python-dev python-setuptools python-pip mongodb-clients mongodb supervisor && \
    pip install virtualenv virtualenvwrapper awscli && \
    curl https://install.meteor.com/ | sh && \
    apt-get clean all

#Config files
COPY mongod-supervisor.conf /etc/supervisor/conf.d/mongod.conf

#Copy necessary repos
COPY grits-net-meteor /
RUN mkdir /example/packages
COPY grits-net-meteor /example/packages/grits-net-meteor
COPY grits-net-mapper /example/packages/grits-net-mapper
COPY grits-net-consume /example/packages/grits-net-consume
COPY flirt-sidebar /example/packages/flirt-sidebar

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

EXPOSE 80
COPY run.sh /run.sh
CMD bash run.sh

