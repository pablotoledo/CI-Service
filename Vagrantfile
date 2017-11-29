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

  # Docker EE node for CentOS 7.3
    config.vm.define "centos-node" do |centos_node|
      centos_node.vm.box = "centos/7"
      #centos_node.vm.network "private_network", type: "dhcp"
      config.vm.network "private_network", ip: "192.168.50.10"
      centos_node.vm.hostname = "centos-node"
      config.vm.provider :virtualbox do |vb|
         vb.customize ["modifyvm", :id, "--memory", "3072"]
         vb.customize ["modifyvm", :id, "--cpus", "2"]
         vb.name = "centos-node"
      end
      
      #Installing Docker CE
      centos_node.vm.provision "shell", inline: <<-SHELL
       sudo yum -y remove docker
       sudo yum -y remove docker-selinux
       sudo yum install -y yum-utils device-mapper-persistent-data lvm2
       sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
       sudo yum install -y docker-ce
       sudo groupadd docker
       sudo usermod -aG docker vagrant
       sudo systemctl enable docker
       sudo systemctl start docker

       #Instalamos Docker Compose
       sudo yum --enablerepo=extras install -y epel-release
       sudo yum -y install python-pip
       sudo pip install docker-compose

       #Lanzamos portainer como administrador de contenedores
       docker run -d -p 9000:9000 --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v /opt/portainer:/data portainer/portainer --no-auth
     SHELL
    end

end
