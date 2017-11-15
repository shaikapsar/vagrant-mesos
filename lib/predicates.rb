# -*- mode: ruby -*-
# vi: set ft=ruby :

def master?(name)
    return /^mesos-master/ =~ name
end

def slave?(name)
    return /^mesos-slave/ =~ name
end

def zookeeper?(name)
    return /^zookeeper/ =~ name
end

def quorum(number)
	return (number.to_f * 50 / 100).ceil()
end