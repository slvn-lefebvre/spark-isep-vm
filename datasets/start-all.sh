#!/bin/sh

# prerequisites
# jdk  1.7 or higher 
# curl
# wget

export DEMO_HOME=`pwd`

# start all
cd $DEMO_HOME

export SPARK_HOME=$DEMO_HOME/spark
export SPARK_LOCAL_IP=localhost
export SPARK_MASTER_IP=localhost


# at this point check http://localhost:8080
# you should see your standalone spark cluster up and running

export ZEPPELIN_HOME=$DEMO_HOME/incubator-zeppelin

$ZEPPELIN_HOME/bin/zeppelin-daemon.sh start

# at this point check http://localhost:8888
# you should see your zeppelin ide
# remember to add spark.cassandra.connection.host = localhost in the spark context
$SPARK_HOME/sbin/start-all.sh 

#last but not least start cassandra
sudo service cassandra start

