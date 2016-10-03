FROM ubuntu:16.04

RUN apt-get update &&\
    apt-get install -y apache2 tomcat8 supervisor curl less vim

# Download openam nightly build war
RUN curl http://download.forgerock.org/downloads/openam/openam_link.js | grep -o "http://.*\.war" | xargs curl -o /var/lib/tomcat8/webapps/openam.war

# Download web agent snapshot
# RUN curl http://download.forgerock.org/downloads/openam/webagents/nightly/Linux/Apache_v24_Linux_64bit_5.0.0-SNAPSHOT.zip

# Setup for openam
RUN chown -R tomcat8:tomcat8 /usr/share/tomcat8 &&\
    echo 127.0.0.1 openam.example.com >> /etc/hosts

# Setup config files
RUN a2enmod ssl
COPY openam-proxy.conf /etc/httpd/conf.d/openam-proxy.conf
COPY supervisor-tomcat.conf /etc/supervisor/conf.d/tomcat.conf
COPY supervisor-apache.conf /etc/supervisor/conf.d/apache.conf

EXPOSE 8080
CMD supervisord --nodaemon --config /etc/supervisor/supervisord.conf
