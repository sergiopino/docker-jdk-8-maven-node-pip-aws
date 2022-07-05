FROM ubuntu:20.04

LABEL maintainer="Sergio Pino <srmpino@gmail.com>"


ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME       /usr/lib/jvm/open-jdk
ENV LANG            en_US.UTF-8
ENV LC_ALL          en_US.UTF-8

#Jdk 8
RUN apt-get update && apt-get install -y openjdk-11-jdk

# Using apt-get due to warning with apt:
# WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
RUN apt-get install -y apt-utils && \
    apt-get install -y \
        automake \
        build-essential \
        cdbs \
        dh-make \
        dh-python \
        devscripts \
        git \
        m4 \
        python3-dev \
        python3-pip \
        python3-distutils-extra \
	libx11-xcb-dev \
	curl \
    # Clean up!
    && rm -rf /var/lib/apt/lists/*

# Node related
# ------------

RUN echo "# Installing Nodejs" && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install nodejs build-essential -y && \
    npm set strict-ssl false && \
    npm install -g npm@latest && \
    npm install -g bower grunt grunt-cli && \
    npm cache clear -f && \
    npm install -g n && \
    n stable

RUN echo "#installing software common" && \
    apt-get update -y  && \
    apt-get install -y software-properties-common

RUN echo "#installing pip aws ebcli" && \
    add-apt-repository universe && \
    apt-get update -y  && \
    apt-get install -y python2 && \
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && \
    python2 get-pip.py && \
    pip3 install awsebcli botocore==1.19.63 --upgrade

#        pip install awsebcli --upgrade && \
#    pip install awscli --upgrade && \
#    pip install awsebcli --upgrade

RUN echo "#installing jq " &&  \
    apt-get install -y jq

# Maven related
# -------------
ENV MAVEN_VERSION 3.8.6
ENV MAVEN_ROOT /var/lib/maven
ENV MAVEN_HOME $MAVEN_ROOT/apache-maven-$MAVEN_VERSION
ENV MAVEN_OPTS -Xms256m -Xmx512m


RUN echo "#installing wget" && \
    apt-get update -y  && \
    apt-get install -y wget

RUN echo "# Installing Maven " && echo ${MAVEN_VERSION} && \
    wget --no-verbose -O /tmp/apache-maven-$MAVEN_VERSION.tar.gz \
    http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    mkdir -p $MAVEN_ROOT && \
    tar xzf /tmp/apache-maven-$MAVEN_VERSION.tar.gz -C $MAVEN_ROOT && \
    ln -s $MAVEN_HOME/bin/mvn /usr/local/bin && \
    rm -f /tmp/apache-maven-$MAVEN_VERSION.tar.gz

VOLUME /var/lib/maven