FROM ubuntu:16.04

# Install apt package dependencies
RUN apt-get clean all && apt-get update && \
    apt-get -y install wget curl python make g++ git cron python-pip && \
    apt-get clean all

RUN pip install jupyter pymongo requests pandas epitator

# Install EpiTator dependencies
RUN python -m spacy download en_core_web_sm
RUN python -m epitator.importers.import_disease_ontology
RUN python -m epitator.importers.import_wikidata

# Install Meteor
RUN curl https://install.meteor.com/ | sh

#Create and use meteor user
RUN groupadd meteor && adduser --ingroup meteor --home /home/meteor meteor
RUN mkdir /app
RUN chown -R meteor:meteor /app
USER meteor

#Add in the repo
RUN git clone --depth 1 https://github.com/ecohealthalliance/ibis.git /app
WORKDIR /app

RUN meteor npm install
RUN meteor build /home/meteor/build --directory

USER root

WORKDIR /home/meteor/build/bundle/programs/server
RUN meteor npm install

WORKDIR /

ENV ROOT_URL http://ibis.eha.io
ENV PORT 80

RUN echo "0 */3 * * * (cd /app && . /.env && MONGO_HOST=\$MONGO_HOST jupyter nbconvert --execute --ExecutePreprocessor.kernel_name=python --ExecutePreprocessor.timeout=None --allow-errors .scripts/rank_events.ipynb --output ../public/rank_events.html) >> cron.log >> cron.error.log" | crontab -

# Start application
CMD ["sh", "-c", "env > /.env && cron && meteor node /home/meteor/build/bundle/main.js"]
