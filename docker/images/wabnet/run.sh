#!/bin/bash
set -e
env
cd /wab-net-website
/venv/bin/python manage.py migrate
/venv/bin/python manage.py import_from_epicollect wabnet.ec5_models
/venv/bin/python manage.py collectstatic --noinput
/venv/bin/python manage.py runserver 0.0.0.0:80
