# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require './lib/gen_node_infos'
require './lib/predicates'
require './lib/zookeeper_info'

base_dir = File.expand_path(File.dirname(__FILE__))
conf = YAML.load_file(File.join(base_dir, "cluster.yml"))
ninfos = gen_node_infos(conf)
zookeeper_connection = zookeeper_connection_info(ninfos[:master])
marathon_connection = marathon_connection_info(ninfos[:master])
zookeeper_sever_id_map = zookeeper_sever_id_mapping(ninfos[:master])
quorum_count=quorum(conf['master_n'])
## vagrant plugins required:
# vagrant-aws, vagrant-berkshelf, vagrant-omnibus, vagrant-hosts, vagrant-cachier
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_check_update = false
    
  # define VMs. all VMs have identical configuration.
  [ninfos[:zk], ninfos[:master], ninfos[:slave]].flatten.each_with_index do |ninfo, i|
    config.vm.define ninfo[:hostname] do |cfg|
 
      cfg.vm.provider :virtualbox do |vb, override|
        override.vm.hostname = ninfo[:hostname]
        override.vm.network :private_network, :ip => ninfo[:ip], :mac=> ninfo[:mac_address]
        override.vm.provision :hosts

        vb.name = ninfo[:hostname]
        vb.customize ["modifyvm", :id, "--memory", ninfo[:mem], "--cpus", ninfo[:cpus] ]

        override.vm.provision :shell do |s|
          s.path = "scripts/populate_sshkey.sh"
          s.args = "/root root"
        end

        override.vm.provision :shell do |s|
          s.path = "scripts/populate_sshkey.sh"
          s.args = "/home/ubuntu ubuntu"
        end
        
        #Update system packages
        override.vm.provision "shell", path: "scripts/upgrade_system_packages.sh"
        #Install Java Package
        override.vm.provision "shell", path: "scripts/install_java.sh"
        #Configure Mesos pacakges.
        override.vm.provision "shell", path: "scripts/configure_mesos_package.sh"

        if master?(ninfo[:hostname]) then
          myid = (/mesos-master-([0-9]+).pmr.shaikapsar.com/.match ninfo[:hostname])[1]
          ip=ninfo[:ip]
          hostname=server_shortname(ninfo[:hostname])
          #hostname=ninfo[:hostname]
          cluster_name=conf['cluster_name']
          override.vm.provision "shell", path: "scripts/configure_mesos_master.sh"
          override.vm.provision :shell, :inline => <<-SCRIPT
            echo #{zookeeper_connection}
            sudo echo #{myid} > /etc/zookeeper/conf/myid
            sudo echo #{zookeeper_connection} > /etc/mesos/zk
            sudo echo #{ip} > /etc/mesos-master/ip
            sudo echo #{hostname} > /etc/mesos-master/hostname
            sudo echo #{quorum_count} > /etc/mesos-master/quorum
            sudo echo #{cluster_name} > /etc/mesos-master/cluster
            sudo echo #{zookeeper_sever_id_map} | cut -b1- | tr '@' '\n' >> /etc/zookeeper/conf/zoo.cfg
            sudo mkdir -p /etc/marathon/conf
            sudo cp /etc/mesos-master/hostname /etc/marathon/conf/hostname
            sudo echo #{zookeeper_connection} /etc/marathon/conf/master
            sudo echo #{marathon_connection} /etc/marathon/conf/zk
            sudo echo manual | sudo tee /etc/init/mesos-slave.override
            sudo service zookeeper restart
            sudo service mesos-master restart
            sudo service marathon restart
          SCRIPT
        end

        if slave?(ninfo[:hostname]) then
          ip=ninfo[:ip]
          hostname=server_shortname(ninfo[:hostname])
          override.vm.provision :shell, :inline => <<-SCRIPT
          sudo apt-get install mesos -y 
          sudo service zookeeper stop
          sudo sh -c "echo manual > /etc/init/zookeeper.override"
          sudo service mesos-master stop
          sudo sh -c "echo manual > /etc/init/mesos-master.override"
          sudo echo #{ip} > /etc/mesos-slave/ip
          sudo echo #{hostname} > /etc/mesos-slave/hostname
          sudo echo #{zookeeper_connection} > /etc/mesos/zk
          sudo service mesos-slave restart
          SCRIPT
        end




        if zookeeper?(ninfo[:hostname]) then
        #  override.vm.provision "shell", path: "scripts/install_zookeeper.sh"
        myid = (/zookeeper-([0-9]+).pmr.shaikapsar.com/.match ninfo[:hostname])[1]
        override.vm.provision :shell, :inline => <<-SCRIPT
        #  sudo apt install ruby -y
          echo "Apsar"
          sudo id -u zookeeper &>/dev/null || sudo useradd -r zookeeper -U
          sudo mkdir -p /var/{lib,data}/zookeeper
          sudo chown zookeeper:zookeeper -R /var/{lib,data}/zookeeper
          sudo echo #{myid} > /var/data/zookeeper/myid
          sudo chmod 755 /var/data/zookeeper/myid
        #  sudo /opt/chef/embedded/bin/ruby /vagrant/scripts/gen_zoo_conf.rb > /etc/zookeeper/conf/zoo.cfg
        #  sudo restart zookeeper
        SCRIPT
      end

      end
    end
  end
end
