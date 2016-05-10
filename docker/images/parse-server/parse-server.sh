#!/bin/bash

source /shared/environment-variables.sh &&\
parse-server --appId $APP_ID --masterKey $MASTER_KEY --databaseURI $MONGO_URL

