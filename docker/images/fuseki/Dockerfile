FROM ubuntu:16.04

ADD supervisord.conf /etc/supervisor/conf.d/fuseki.conf

# Install dependencies
# Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get -y install git python supervisor software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean all

WORKDIR /tmp
RUN wget http://apache.claz.org/jena/binaries/apache-jena-fuseki-2.4.0.tar.gz
RUN echo "f2ed1586629ad0558bcf42e99a74657e *apache-jena-fuseki-2.4.0.tar.gz" | md5sum -c -
RUN tar -xvzf apache-jena-fuseki-2.4.0.tar.gz && \
    mv apache-jena-fuseki-2.4.0 /apache-jena-fuseki && \
    rm apache-jena-fuseki-2.4.0.tar.gz

WORKDIR /apache-jena-fuseki
RUN mkdir DB
RUN git clone https://github.com/ecohealthalliance/t11

EXPOSE 3030

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisor/supervisord.conf"]
