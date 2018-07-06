#!/bin/bash
set -e
cd /wab-net-website
python manage.py makemigrations wabnet
python manage.py migrate
python import_from_epicollect.py
python manage.py runserver
