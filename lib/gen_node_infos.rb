# -*- mode: ruby -*-
# vi: set ft=ruby :

def gen_node_infos(cluster_yml)
  master_n = cluster_yml['master_n']
  master_mem = cluster_yml['master_mem']
  master_cpus = cluster_yml['master_cpus']
  slave_n = cluster_yml['slave_n']
  slave_mem = cluster_yml['slave_mem']
  slave_cpus = cluster_yml['slave_cpus']
  zk_n = cluster_yml['zk_n']
  zk_mem = cluster_yml['zk_mem']
  zk_cpus = cluster_yml['zk_cpus']
  master_ipbase = cluster_yml['master_ipbase']
  slave_ipbase = cluster_yml['slave_ipbase']
  zk_ipbase = cluster_yml['zk_ipbase']
  mac_base = cluster_yml['mac_base']
  zk_instance_type = cluster_yml['zk_instance_type']
  master_instance_type = cluster_yml['master_instance_type']
  slave_instance_type = cluster_yml['slave_instance_type']

  master_infos = (1..master_n).map do |i|
                   { :hostname => "mesos-master-#{i}.pmr.shaikapsar.com",
                     :ip => master_ipbase + "#{120+i}",
                     :mem => master_mem,
                     :cpus => master_cpus,
                     :instance_type => master_instance_type,
                     :mac_address => mac_base + "#{20+i}"
                   }
                 end
  slave_infos = (1..slave_n).map do |i|
                   { :hostname => "mesos-slave-#{i}.pmr.shaikapsar.com",
                     :ip => slave_ipbase + "#{130+i}",
                     :mem => slave_mem,
                     :cpus => slave_cpus,
                     :instance_type => slave_instance_type,
                     :mac_address => mac_base + "#{30+i}"
                   }
                 end
  zk_infos = (1..zk_n).map do |i|
               { :hostname => "zookeeper-#{i}.pmr.shaikapsar.com",
                 :ip => zk_ipbase + "#{110+i}",
                 :mem => zk_mem,
                 :cpus => zk_cpus,
                 :instance_type => zk_instance_type,
                 :mac_address => mac_base + "#{10+i}"
               }
             end

  return { :master => master_infos, :slave=>slave_infos, :zk=>zk_infos }
end
