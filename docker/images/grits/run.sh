#!/bin/bash
# Load environment variables from shared folder
source /shared/docker.env
# Try to download premade database
wget -O $ANNOTATOR_DB_PATH https://s3.amazonaws.com/bsve-integration/annotator.sqlitedb
(
  $GRITS_HOME/grits_env/bin/python -m epitator.importers.import_all &&
  supervisord --nodaemon --config /etc/supervisor/supervisord.conf
)
