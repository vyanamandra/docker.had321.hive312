FROM debian:9

MAINTAINER Venu Yanamandra <venu.yanamandra@yahoo.com>

USER root

# Prerequisites
RUN apt update && DEBIAN_FRONTEND=noninteractive apt upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      openjdk-8-jdk \
      net-tools \
      curl \
      netcat \
      procps \
      nmap \
      gnupg \
      libsnappy-dev \
      binutils \
      openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://dist.apache.org/repos/dist/release/hadoop/common/KEYS
RUN gpg --import KEYS

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV HADOOP_VER 3.2.1
ENV HIVE_VER 3.1.2
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VER/hadoop-$HADOOP_VER.tar.gz
ENV HIVE_URL https://downloads.apache.org/hive/hive-${HIVE_VER}/apache-hive-${HIVE_VER}-bin.tar.gz
ENV MYSQL_CONNECTOR https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java_8.0.20-1debian9_all.deb

ENV JAVA_HOME $(readlink -f /usr/bin/java | sed "s:bin/java::")
RUN echo "JAVA_HOME=${JAVA_HOME} ; export JAVA_HOME" >> /etc/profile
ENV PATH $PATH:$JAVA_HOME/bin

RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HIVE_URL" -o /tmp/apache-hive-3.1.2.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && curl -fSL "$MYSQL_CONNECTOR" -o /tmp/mysql-connector-java.deb \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /usr/local/ \
    && tar -xzf /tmp/apache-hive-3.1.2.tar.gz -C /usr/local/ \
    && rm /tmp/apache-hive-3.1.2.tar.gz \
    && rm /tmp/hadoop.tar.gz*

RUN DEBIAN_FRONTEND=noninteractive apt install /tmp/mysql-connector-java.deb -y && \
    rm -f /tmp/mysql-connector-java.deb

RUN ln -s /usr/local/hadoop-$HADOOP_VER /usr/local/hadoop
RUN ln -s /usr/local/apache-hive-${HIVE_VER}-bin /usr/local/hive
RUN cp /usr/share/java/mysql-connector-java-8.0.20.jar /usr/local/hive/lib

# Passwordless SSH
RUN sed -i '/^#PermitRootLogin/s/^.*$/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN ssh-keygen -q -t rsa -P '' -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN service ssh start

ENV HADOOP_HOME /usr/local/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV HADOOP_COMMON_HOME $HADOOP_HOME
ENV HADOOP_HDFS_HOME $HADOOP_HOME
ENV HADOOP_MAPRED_HOME $HADOOP_HOME
ENV HADOOP_YARN_HOME $HADOOP_HOME
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV HIVE_HOME /usr/local/hive
ENV PATH $PATH:$HIVE_HOME/bin


# Default Conf Files
ADD config/* $HADOOP_HOME/etc/hadoop/
ADD hive-site.xml $HIVE_HOME/conf

WORKDIR $HADOOP_HOME

RUN echo '' > /usr/local/hadoop/etc/hadoop/venus
ADD bootstrap.sh /etc/bootstrap.sh
ADD runOnce.sh /etc/runOnce.sh
ADD hadoop_bootstrap.sh /etc/hadoop_bootstrap.sh
ADD hive_bootstrap.sh /etc/hive_bootstrap.sh

EXPOSE 10000 9083 8020 9000 50070 50075 50020 50090 

CMD ["/etc/bootstrap.sh", "-d"]
