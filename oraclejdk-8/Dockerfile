# Pull base ubuntu image.
FROM ubuntu 

# Maintainer
# ----------
MAINTAINER David Winters <dwinters@c2b2.co.uk>

ENV PAYARA_PKG https://s3-eu-west-1.amazonaws.com/payara.co/Payara+Downloads/Payara+4.1.1.154/payara-4.1.1.154.zip
ENV PKG_FILE_NAME payara-4.1.1.154.zip

# Install packages on ubuntu base image

RUN \
 apt-get update && \ 
 apt-get install -y unzip && \
 apt-get install -y curl && \ 
 apt-get install -y software-properties-common python-software-properties


# Install Java 8, agree to oracle jdk license

RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \ 
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# add payara user, download payara nightly build and unzip
RUN useradd -b /opt -m -s /bin/bash payara && echo payara:payara | chpasswd
RUN cd /opt && curl -O $PAYARA_PKG && unzip $PKG_FILE_NAME && rm $PKG_FILE_NAME
RUN chown -R payara:payara /opt/payara41*
RUN apt-get clean

# Default payara ports to expose
EXPOSE 4848 8009 8080 8181

# Set up payara user and the home directory for the user
USER payara
WORKDIR /opt/payara41/glassfish/bin

# User: admin / Pass: glassfish
RUN \
  echo "AS_ADMIN_PASSWORD=glassfish" > pwdfile && \
  for D in domain1 payaradomain; do \
     echo "admin;{SSHA256}80e0NeB6XBWXsIPa7pT54D9JZ5DR5hGQV1kN1OAsgJePNXY6Pl0EIw==;asadmin" > /opt/payara41/glassfish/domains/${D}/config/admin-keyfile ; \
  done

# enable secure admin to access DAS remotely. Note we are using the domain payaradomain
RUN \
  for D in domain1 payaradomain; do \
     ./asadmin start-domain ${D} && \
     ./asadmin --user admin --passwordfile pwdfile enable-secure-admin && \
     ./asadmin stop-domain ${D} ; \
  done

RUN echo "export PATH=$PATH:/opt/payara41/glassfish/bin" >> /opt/payara/.bashrc
