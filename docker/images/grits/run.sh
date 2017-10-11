#!/bin/bash
# Wait before launching anything incase the container is restarted to make a config change.
sleep 12
# Load environment variables from shared folder
source /shared/docker.env
# Try to download premade database
if [ ! -f "/shared/.db_download_complete" ]; then
    wget -O $ANNOTATOR_DB_PATH https://s3.amazonaws.com/bsve-integration/annotator.sqlitedb &&
    touch /shared/.db_download_complete
fi
(
  $GRITS_HOME/grits_env/bin/python -m epitator.importers.import_all &&
  touch /shared/.db_download_complete &&
  supervisord --nodaemon --config /etc/supervisor/supervisord.conf
)
