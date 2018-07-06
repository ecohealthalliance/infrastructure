#!/bin/bash
set -e
env
cd /wab-net-website
/venv/bin/python manage.py makemigrations wabnet
/venv/bin/python manage.py migrate
/venv/bin/python import_from_epicollect.py
/venv/bin/python manage.py collectstatic --noinput
/venv/bin/python manage.py runserver
