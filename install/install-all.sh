#!/bin/sh
export MAVEN_VERSION=3.3.1
export MAVEN_HOME=/usr/apache-maven-$MAVEN_VERSION

# prerequisites
# jdk  1.7 or higher 
# git
# npm
# maven 
# curl
# wget
# tar

export DEMO_HOME=`pwd`
curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -
sh -c 'echo "deb http://debian.datastax.com/community/ stable main" >> /etc/apt/sources.list.d/datastax.list'
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" > /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886

echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections


apt-get update
apt-get install -y git npm net-tools unzip python libfontconfig

ln -fs /usr/bin/nodejs /usr/bin/node

wget -c "http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
tar zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz -C /usr/
ln -s ${MAVEN_HOME} /usr/maven

# JAVA
export JAVA_HOME=/usr/lib/jvm/java-7-oracle
export PATH=$PATH:$JAVA_HOME/bin

echo
echo
echo "Installing Java"


export DEBIAN_FRONTEND=noninteractive 
apt-get update

apt-get install -y --force-yes oracle-java7-installer oracle-java7-set-default
java -version


export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"

### SPARK 1.3.1 #####################################################

cd $DEMO_HOME;
# build from source spark and install artifacts locally in .m2
git clone https://github.com/apache/spark.git

export SPARK_HOME=$DEMO_HOME/spark

cd $SPARK_HOME
git checkout v1.4.1

${MAVEN_HOME}/bin/mvn clean package install -DskipTests

cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf
echo >> $SPARK_HOME/conf/spark-defaults.conf
echo "spark.cassandra.connection.host    localhost" >> $SPARK_HOME/conf/spark-defaults.conf

cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh
echo >> $SPARK_HOME/conf/spark-env.sh
echo "export SPARK_LOCAL_IP=localhost" >> $SPARK_HOME/conf/spark-env.sh
echo "export SPARK_MASTER_IP=localhost" >> $SPARK_HOME/conf/spark-env.sh
echo "export SPARK_MASTER_WEBUI_PORT=4040" >> $SPARK_HOME/conf/spark-env.sh

sed 's/log4j.rootCategory=INFO, console/log4j.rootCategory=WARN, console/' \
    $SPARK_HOME/conf/log4j.properties.template > $SPARK_HOME/conf/log4j.properties

### CASSANDRA #################################################

echo
echo
echo "Installing Cassandra"
apt-get install -y cassandra=2.1.5
service cassandra stop

#######################################################################
### SPARK-CASSANDRA_CONNECTOR ########################################

cd $DEMO_HOME;
# build from source spark and install artifacts locally in .m2
git clone https://github.com/datastax/spark-cassandra-connector.git

export SPARK_CASSANDRA_CONNECTOR_HOME=$DEMO_HOME/spark-cassandra-connector
cd $SPARK_CASSANDRA_CONNECTOR_HOME
git checkout tags/v1.4.1
rm sbt/*.jar
sbt/sbt clean assembly

#######################################################################
### ZEPPELIN ##########################################################

cd $DEMO_HOME
# build zeppelin from source using spark 1.3.1
git clone https://github.com/apache/incubator-zeppelin.git
ZEPPELIN_HOME=$DEMO_HOME/incubator-zeppelin

cd $ZEPPELIN_HOME
git checkout e4743e71d2421f5b6950f9e0f346f07bb84f1671
${MAVEN_HOME}/bin/mvn -Pspark-1.4 -Dspark.version=1.4.1 -DskipTests clean package

cp $ZEPPELIN_HOME/conf/zeppelin-env.sh.template $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo >> $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export MASTER=spark://localhost:7077" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export SPARK_HOME=$SPARK_HOME" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh 
echo "export ZEPPELIN_PORT=8080" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export ZEPPELIN_JAVA_OPTS=\"-Dspark.jars=$SPARK_CASSANDRA_CONNECTOR_HOME/spark-cassandra-connector-java/target/scala-2.10/spark-cassandra-connector-java-assembly-1.4.1-SNAPSHOT.jar\"" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export ZEPPELIN_NOTEBOOK_DIR=\"$DEMO_HOME/notebooks/zeppelin\"" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export ZEPPELIN_MEM=\"-Xmx1024m\"" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh

#######################################################################
# That's all folks
# prerequisites
# jdk  1.7 or higher 
# curl
# wget

cat /dev/zero | ssh-keygen -t rsa -q -N ""
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# start all
cd $DEMO_HOME

export SPARK_HOME=$DEMO_HOME/spark
export SPARK_LOCAL_IP=localhost
export SPARK_MASTER_IP=localhost

echo "$SPARK_HOME/sbin/start-all.sh --webui-port 4040"
$SPARK_HOME/sbin/start-all.sh

# at this point check http://localhost:4040
# you should see your standalone spark cluster up and running

export ZEPPELIN_HOME=$DEMO_HOME/incubator-zeppelin

$ZEPPELIN_HOME/bin/zeppelin-daemon.sh start

service cassandra start
