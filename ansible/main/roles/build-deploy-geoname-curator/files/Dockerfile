FROM ubuntu:16.04

# Install apt package dependencies
RUN apt-get clean all && apt-get update && \
    apt-get -y install wget curl make g++ git build-essential bsdtar && \
    apt-get clean all

# Install nodejs
#RUN wget https://nodejs.org/download/release/v8.9.1/node-v8.9.1-linux-x64.tar.gz && \
#    tar -zxf node-v8.9.1-linux-x64.tar.gz && \
#    rm node-v8.9.1-linux-x64.tar.gz
#ENV PATH $PATH:/node-v8.9.1-linux-x64/bin
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs


# Install Meteor
#RUN curl https://install.meteor.com/ | sh
ARG METEOR_VERSION=1.6
# Install Meteor
RUN curl https://install.meteor.com --output /tmp/install-meteor.sh && \
	# Set the release version in the install script
	sed --in-place "s/RELEASE=.*/RELEASE=\"$METEOR_VERSION\"/g" /tmp/install-meteor.sh && \
	# Replace tar with bsdtar in the install script; https://github.com/jshimko/meteor-launchpad/issues/39
	sed --in-place "s/tar -xzf.*/bsdtar -xf \"\$TARBALL_FILE\" -C \"\$INSTALL_TMPDIR\"/g" /tmp/install-meteor.sh && \
	# Install Meteor
	printf "\n[-] Installing Meteor $METEOR_VERSION...\n\n" && \
	sh /tmp/install-meteor.sh

#Create and use meteor user
RUN groupadd meteor && adduser --ingroup meteor --home /home/meteor meteor
RUN mkdir /app
#Add in the repo
ADD GeoName-Curator /app
RUN chown -R meteor:meteor /app
USER meteor

WORKDIR /app

RUN meteor list
RUN meteor npm install
RUN meteor build /home/meteor/build --directory

USER root

WORKDIR /home/meteor/build/bundle/programs/server
RUN meteor npm install

WORKDIR /

ENV ROOT_URL http://geoname-curator.eha.io
ENV PORT 80

ADD run.sh .

# Start application
CMD /bin/bash /run.sh
