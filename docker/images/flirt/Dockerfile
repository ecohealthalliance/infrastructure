FROM node:0.12

#Install dependencies
RUN apt-get clean all && apt-get update
RUN apt-get -y install build-essential python python-dev python-setuptools python-pip mongodb-clients mongodb supervisor
RUN pip install virtualenv virtualenvwrapper awscli
RUN curl https://install.meteor.com/ | sh

#Config files
COPY mongod-supervisor.conf /etc/supervisor/conf.d/mongod.conf

#Copy necessary repos
COPY grits-net-meteor /
RUN mkdir /example/packages
COPY grits-net-meteor /example/packages/grits-net-meteor
COPY grits-net-mapper /example/packages/grits-net-mapper
COPY grits-net-consume /example/packages/grits-net-consume

#Build the meteor app
WORKDIR /example
RUN meteor build ./gritsbuild --directory || exit 1
WORKDIR /example/gritsbuild/bundle/programs/server
RUN npm install
WORKDIR /

#Setup AWS config
RUN mkdir /root/.aws
ENV AWS_ACCESS_KEY_ID=AKIAJLKTQX7LL2L2JV7Q
ENV AWS_SECRET_ACCESS_KEY=Y9cT3LojWqDFBa+Yh4KvZiKXE/oCVWicbLDgTsNT

EXPOSE 80
COPY run.sh /run.sh
CMD bash run.sh

