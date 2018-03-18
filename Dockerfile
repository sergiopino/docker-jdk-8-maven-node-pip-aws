FROM node:9.2.1-alpine
LABEL maintainer="Sergio Pino <srmpino@gmail.com>"

ENV CHROME_BIN /usr/bin/chromium-browser

RUN apk update && apk upgrade

#JAVA
RUN apk add --no-cache \
    curl \
    tar \
    bash \
    procps \
    zip \
    udev \
    ttf-freefont \
    chromium \
    openjdk8 \
    git \
    openssh \
    mysql-client \
    python-dev 

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

#AWS
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install awsebcli --upgrade && \
    pip install awscli --upgrade && \
    pip install awsebcli --upgrade

#Maven
ENV MAVEN_VERSION 3.5.3
ENV MAVEN_HOME /usr/lib/maven
ENV PATH /usr/lib/maven/bin:$JAVA_HOME/bin:$PATH

RUN apk --no-cache add --virtual build-dependencies wget && \
    cd /tmp && \
    wget -q http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O - | tar xzf - && \
    mv /tmp/apache-maven-$MAVEN_VERSION /usr/lib/maven && \
    ln -s /usr/lib/maven/bin/mvn /usr/bin/mvn && \
    rm -rf /tmp/* && \
    apk del --purge build-dependencies
