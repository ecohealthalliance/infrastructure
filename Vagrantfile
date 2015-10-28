# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "public_network"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "2048"
    vb.cpus = "2"
  end

  config.vm.provision "shell" do |s| 
    s.privileged = true
    s.inline = <<-SHELL
      # Check that HTTPS transport is available to APT
      if [ ! -e /usr/lib/apt/methods/https ]; then
        apt-get update
        apt-get install -y apt-transport-https
      fi

      # Add docker apt repo and import GPG key
      echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list
      apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

      #Install docker
      apt-get update
      apt-get install -y lxc-docker
    SHELL
  end
end