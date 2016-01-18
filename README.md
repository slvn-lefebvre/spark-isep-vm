# Vagrant machine with spark cassandra and zeppelin

## Summary

This vm originally comes from :  https://github.com/natalinobusa/gowalla-spark-demo

Spark and Cassandra provide a good alternative to traditional big data architectures based on Hadoop, by bringing the operational and the analytic world closer to each other. In this post/tutorial I will show how to combine Cassandra and Spark to get the best of those two technologies.

Provides the demo described in:
Tutorial: http://www.natalinobusa.com/2015/07/clustering-check-ins-with-spark-and.html

### Install and setup

- install vagrant

```sh
sudo apt-get install vagrant
```

- clone the vm and create appropriate directories

```sh
git clone https://github.com/slvn-lefebvre/spark-isep-vm.git
```
- Login in the vm and start all components

```sh
vagrant ssh
sudo sh /opt/dataset/start-all.sh
```

### Run it!

Spark is configured to run in cluster mode (albeit on a single node), a password might be prompted, since the master and the workers of spark communicate via ssh. This shoudl be the default vagrant vm password.

Some headstart:
- Spark web interface: http://localhost:4040/
- Zeppelin: http://localhost:8080/

Cassandra can be accessed with the cqlsh command line interface. After installing and seting up the system, type `./apache-cassandra-2.1.7/bin/cqlsh` from the root of the git project, to start the cql client.
