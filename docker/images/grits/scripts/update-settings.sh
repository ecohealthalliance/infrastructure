#!/bin/bash
source /source-vars.sh || exit 1

#Grits environment configuration
cd $GRITS_HOME &&\
rm grits_config &&\
touch grits_config &&\
chown grits:grits grits_config &&\
echo "export CLASSIFIER_DATA_ACCESS_KEY=$CLASSIFIER_DATA_ACCESS_KEY" >> grits_config
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


#Grits API config file
cd $GRITS_HOME/grits-api &&\
rm config.py &&\
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


#Diagnostic Dashboard config file
cd $GRITS_HOME/diagnostic-dashboard &&\
rm config &&\
touch config &&\
echo "export PORT=$PORT" >> config &&\
echo "export MONGO_URL=$MONGO_URL/$METEOR_DB_NAME" >> config &&\
echo "export ROOT_URL=$ROOT_URL" >> config &&\
echo "export MAIL_URL=$MAIL_URL" >> config


