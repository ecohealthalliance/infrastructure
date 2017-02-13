#!/bin/bash
# Try to download premade database
wget -O $ANNOTATOR_DB_PATH https://s3.amazonaws.com/bsve-integration/annotator.sqlitedb
$GRITS_HOME/grits_env/bin/python -m annotator.sqlite_import_geonames && supervisord --nodaemon --config /etc/supervisor/supervisord.conf
