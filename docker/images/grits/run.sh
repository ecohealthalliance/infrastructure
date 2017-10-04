#!/bin/bash
# Load environment variables from shared folder
source /shared/docker.env
# Try to download premade database
if [ ! -f "$ANNOTATOR_DB_PATH" ]; then
    wget -O $ANNOTATOR_DB_PATH https://s3.amazonaws.com/bsve-integration/annotator.sqlitedb
fi
(
  $GRITS_HOME/grits_env/bin/python -m epitator.importers.import_all &&
  supervisord --nodaemon --config /etc/supervisor/supervisord.conf
)
