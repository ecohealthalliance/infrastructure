FROM ubuntu:18.04

# Install apt package dependencies
RUN apt-get clean all && apt-get update && \
    apt-get -y install build-essential python-dev python-pip python3-distutils software-properties-common && \
    apt-get clean all

COPY wab-net-website /wab-net-website

RUN pip install virtualenv setuptools

RUN virtualenv /venv --python=python3 &&\
    cd /wab-net-website &&\
    /venv/bin/pip install -r requirements.pip

COPY run.sh /run.sh
CMD bash run.sh
