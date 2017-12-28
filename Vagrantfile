# -*- mode: ruby -*-
# vi: set ft=ruby :

# Author: Pablo Toledo Gavagnin

# If you are using a corportive proxy you need:
# - Install proxy plugin for Vagrant
#       vagrant plugin install vagrant-proxyconf
# - Run Vagrant using enviroment variables for Vagrant:
#       VAGRANT_HTTP_PROXY="http://proxy:port" VAGRANT_HTTPS_PROXY="http://proxy:port" vagrant up

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
    config.vm.define "ci-service" do |ci_service|
      ci_service.vm.box = "centos/7"
      #ci_service.vm.network "private_network", type: "dhcp"
      config.vm.network "private_network", ip: "192.168.50.10"
      ci_service.vm.hostname = "ci-service"
      config.vm.provider :virtualbox do |vb|
         vb.customize ["modifyvm", :id, "--memory", "4096"]
         vb.customize ["modifyvm", :id, "--cpus", "2"]
         vb.name = "ci-service"
      end
      
      # Installing Docker CE
      ci_service.vm.provision "shell", inline: <<-SHELL
        sudo yum -y remove docker
        sudo yum -y remove docker-selinux
        sudo yum install -y yum-utils device-mapper-persistent-data lvm2
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce
        sudo groupadd docker
        sudo usermod -aG docker vagrant
        sudo systemctl enable docker
        sudo systemctl start docker

        # If we have a corporative proxy, we set this enviroment vars to docker
        # https://docs.docker.com/engine/admin/systemd/#httphttps-proxy
        if [ ! -z "$HTTP_PROXY" ]; then
          sudo echo "Setting in Docker CE HTTP_PROXY: $HTTP_PROXY"
          sudo mkdir -p /etc/systemd/system/docker.service.d
          sudo echo '[Service]' >> /etc/systemd/system/docker.service.d/http-proxy.conf
          sudo echo Environment="HTTP_PROXY=$HTTP_PROXY" >> /etc/systemd/system/docker.service.d/http-proxy.conf
          sudo cat /etc/systemd/system/docker.service.d/http-proxy.conf
          sudo systemctl daemon-reload
          sudo systemctl restart docker
        fi
        if [ ! -z "$HTTPS_PROXY" ]; then
          sudo echo "Setting in Docker CE HTTPS_PROXY: $HTTPS_PROXY"
          sudo mkdir -p /etc/systemd/system/docker.service.d
          sudo echo '[Service]' >> /etc/systemd/system/docker.service.d/https-proxy.conf
          sudo echo Environment="HTTPS_PROXY=$HTTPS_PROXY" >> /etc/systemd/system/docker.service.d/https-proxy.conf
          sudo cat /etc/systemd/system/docker.service.d/https-proxy.conf
          sudo systemctl daemon-reload
          sudo systemctl restart docker
        fi

        # Installing Docker Compose
        sudo yum --enablerepo=extras install -y epel-release
        sudo yum -y install python-pip
        sudo pip install docker-compose
     SHELL

     # Running containers...
     ci_service.vm.provision "shell", inline: <<-SHELL
        # Running Portainer to manage Docker Containers
        docker run -d -p 9000:9000 --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v /opt/portainer:/data portainer/portainer --no-auth
        docker start portainer
        
        # Creating folders for Volumes
        mkdir -p /vagrant/volumes/gilab/
        mkdir -p /vagrant/volumes/sonarqube/opts/
        mkdir -p /vagrant/volumes/sonarqube/data/
        mkdir -p /vagrant/volumes/sonarqube/extensions/
        mkdir -p /vagrant/volumes/sonarqube/plugins/
        mkdir -p /vagrant/volumes/postgresql/config/
        mkdir -p /vagrant/volumes/postgresql/data/

        # Inflating Volumes from ZIPS
        bash -c "mv /vagrant/CI-Dockerfiles/gitlab-ce/gitlab.tar.gz /vagrant/volumes/gitlab.tar.gz; cd /vagrant/volumes/; tar xvf gitlab.tar.gz"
        bash -c "cd /vagrant/CI-Dockerfiles; docker-compose up -d db jenkins sonarqube nexus gitlab"
     SHELL
    end

end
