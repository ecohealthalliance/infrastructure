#!/bin/bash
cd /data

mkdir -p dumps

rm -f virtuoso.ini
cp /virtuoso.ini . 2>/dev/null

chmod +x /clean-logs.sh
rm -f clean-logs.sh
cp /clean-logs.sh . 2>/dev/null

if [ ! -f ".dba_pwd_set" ];
then
  touch /sql-query.sql
  if [ "$DBA_PASSWORD" ]; then echo "user_set_password('dba', '$DBA_PASSWORD');" >> /sql-query.sql ; fi
  if [ "$SPARQL_UPDATE" = "true" ]; then echo "GRANT SPARQL_UPDATE to \"SPARQL\";" >> /sql-query.sql ; fi
  virtuoso-t +wait && isql-v -U dba -P dba < /dump_nquads_procedure.sql && isql-v -U dba -P dba < /sql-query.sql
  kill $(ps aux | grep '[v]irtuoso-t' | awk '{print $2}')
  touch .dba_pwd_set
fi

if [ ! -f ".data_loaded" ];
then
    echo "starting data loading"
    pwd="dba"
    graph="http://localhost:8890/DAV"

    if [ "$DBA_PASSWORD" ]; then pwd="$DBA_PASSWORD" ; fi
    if [ "$DEFAULT_GRAPH" ]; then graph="$DEFAULT_GRAPH" ; fi
    echo "ld_dir('toLoad', '*', '$graph');" >> /load_data.sql
    echo "rdf_loader_run();" >> /load_data.sql
    echo "exec('checkpoint');" >> /load_data.sql
    echo "WAIT_FOR_CHILDREN; " >> /load_data.sql
    echo "$(cat /load_data.sql)"
    virtuoso-t +wait && isql-v -U dba -P "$pwd" < /load_data.sql
    kill $(ps aux | grep '[v]irtuoso-t' | awk '{print $2}')
    touch .data_loaded
fi

# The following error occurs after loading a large amount of data then restarting Virtuoso:
#
#   Unable to lock file /usr/local/virtuoso-opensource/var/lib/virtuoso/db/virtuoso.lck (Resource temporarily unavailable).
#   Virtuoso is already runnning (pid 45)
#   This probably means you either do not have permission to start
#   this server, or that virtuoso-t is already running.
#   If you are absolutely sure that this is not the case, please try
#   to remove the file /usr/local/virtuoso-opensource/var/lib/virtuoso/db/virtuoso.lck and start again.
#
# The sleep command and lock removal are intended to avoid the issue.
sleep 60
rm /data/virtuoso.lck

virtuoso-t +wait +foreground
