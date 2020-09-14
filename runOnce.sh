#!/usr/bin/env bash
JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::") ; export JAVA_HOME

# Have to do this in 2 steps since docker complains of device being busy.
#  Hint: the inode changes and docker does not like it
#   Ref: https://unix.stackexchange.com/questions/404189/find-and-sed-string-in-docker-got-error-device-or-resource-busy
sed '/^127.0.0.1/ s/$/ hadoop-master hadoop-slave1/' /etc/hosts > /tmp/hosts.edit.tmp
cat /tmp/hosts.edit.tmp > /etc/hosts && rm -f /tmp/hosts.edit.tmp

# Modify the ownership of hadoop-env.sh and chmod to make is an executable
chown -R root:root $HADOOP_HOME/etc/hadoop/hadoop-env.sh
chmod u+x $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# Ensure JAVA_HOME, HADOOP_HOME are setup properly in hadoop-env.sh
FR="^export JAVA_HOME"; if [ $(grep "^export JAVA_HOME" ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh | wc -l)  -eq 0 ]; then FR="export JAVA_HOME"; fi; sed -i "/${FR}/ s:.*:export JAVA_HOME=${JAVA_HOME}\nexport HADOOP_HOME=${HADOOP_HOME}\nexport HADOOP_HOME=${HADOOP_HOME}:" ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh

# Ensure HADOOP_CONF_DIR is setup properly in hadoop-env.sh
FR="^export HADOOP_CONF_DIR"; if [ $(grep "${FR}" ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh | wc -l)  -eq 0 ]; then FR="export HADOOP_CONF_DIR"; fi; sed -i "/${FR}/ s:.*:export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop/:" $HADOOP_HOME/etc/hadoop/hadoop-env.sh


# Ensure HADOOP_LOG_DIR is setup properly in hadoop-env.sh
FR="^export HADOOP_LOG_DIR"; if [ $(grep "${FR}" ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh | wc -l)  -eq 0 ]; then FR="export HADOOP_LOG_DIR"; fi; sed -i "/${FR}/ s:.*:export HADOOP_LOG_DIR=/logs/hadoop/:" $HADOOP_HOME/etc/hadoop/hadoop-env.sh


# Ensure HDFS [namenode, datanode, logs] & HIVE [logs]  directories are created
mkdir -p /hdfs/data/hdfs/namenode/ \
	/hdfs/data/hdfs/datanode/ \
	/logs/hadoop/ \
	/logs/hive/hs2/ \
	/logs/hive/hms/

# Format the namenode on first use.
hdfs namenode -format > /dev/null 2>&1

# Conflicting guava jars cause an issue when running 
#  Hadoop: 3.2.1 & Hive 3.1.2
#   Ref: https://issues.apache.org/jira/browse/HIVE-22915
rm -f /usr/local/hive/lib/guava-19.0.jar
cp /usr/local/hadoop/share/hadoop/hdfs/lib/guava-27.0-jre.jar /usr/local/hive/lib/

# Initialize the Hive Metastore schema
$HIVE_HOME/bin/schematool -initSchema -dbType mysql

echo "If you get an error from schematool indicating it failed since the schema already exists, please ignore."

# Remove the runOnce reference from the original bootstrap script
#  Only to prevent someone executing the bootstrap script manually from running this unnecessarily
sed -i '/^\/etc\/runOnce.sh$/d' /etc/bootstrap.sh
