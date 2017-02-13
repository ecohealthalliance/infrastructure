#!/bin/bash
$GRITS_HOME/grits_env/bin/python -m annotator.sqlite_import_geonames
supervisord --nodaemon --config /etc/supervisor/supervisord.conf
