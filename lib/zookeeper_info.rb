# -*- mode: ruby -*-
# vi: set ft=ruby :

def zookeeper_connection_info(zookeeper_instances)
	zk_connection=zk_connection_info_without_prefix(zookeeper_instances)
	return zk_connection + "/mesos"
end

def marathon_connection_info(zookeeper_instances)
	zk_connection=zk_connection_info_without_prefix(zookeeper_instances)
	return zk_connection + "/marathon"
end

def zk_connection_info_without_prefix(zookeeper_instances)
	zk_connection="zk://"
	zookeeper_instances.flatten.each_with_index do |ninfo, i|
	  zk_connection = zk_connection + ninfo[:ip] + ":2181,"
	end
	zk_connection = zk_connection.chomp(",")
	return zk_connection
end

def zookeeper_sever_id_mapping(zookeeper_instances)
	content=""
	zookeeper_instances.flatten.each_with_index do |ninfo, i|
	   myid = (/mesos-master-([0-9]+).pmr.shaikapsar.com/.match ninfo[:hostname])[1]
	   #content = content + server_shortname(ninfo[:hostname]) + "." + myid + "=" + ninfo[:ip] +":2888:3888@"
	   content = content + "server." + myid + "=" + ninfo[:ip] +":2888:3888@"
	end
	content  = content.chomp("@")
	return content
end

def server_shortname(name)
	return name.chomp(".pmr.shaikapsar.com")
end
