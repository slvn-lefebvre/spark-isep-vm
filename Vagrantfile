# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

    # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  #
  # APACHE ZEPPELIN
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8081, host: 8081
  config.vm.network "forwarded_port", guest: 8082, host: 8082

  #
  # APACHE SPARK UI
  config.vm.network "forwarded_port", guest: 4040, host: 4040
  config.vm.network "forwarded_port", guest: 4041, host: 4041
  # CASSANDRA
  # 7000: intra-node communication
  config.vm.network "forwarded_port", guest: 7000, host: 7000
  # 7001: TLS intra-node communication
  config.vm.network "forwarded_port", guest: 7001, host: 7001
  # 7199: JMX
  config.vm.network "forwarded_port", guest: 7199, host: 7199
  # 9042: CQL
  config.vm.network "forwarded_port", guest: 9042, host: 9042
  # 9160: thrift service
  config.vm.network "forwarded_port", guest: 9160, host: 9160
  

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--memory", "4096"]
  end

  config.vm.synced_folder "./datasets", "/opt/datasets"
  config.vm.synced_folder "./notebooks", "/home/vagrant/notebooks"
  config.vm.synced_folder "./mavendeps", "/root/.m2"
  config.vm.synced_folder "./npm-cache", "/root/.npm"
  # View the documentation for the provider you're using for more
  # information on available options.
  config.vm.provision :shell, :path => "bootstrap.sh"
  
end
