#!/bin/bash
if [[ -z "$@" ]]; then
    echo >&2 "You must supply an argument!"
    exit 1
fi
echo "dump_nquads ('$1', 1, 1000000000, 1);" | isql-v -U dba -P $DBA_PASSWORD
