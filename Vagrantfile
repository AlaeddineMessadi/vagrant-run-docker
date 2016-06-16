# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # Vagrant user 'root'
  config.ssh.username = "root"

  # Provider
  config.vm.provider "docker" do |docker|
     # The image name to use
     docker.image = "alaeddine/vagrant-run-docker"

     # Use vagrant docker images SSH
     docker.has_ssh = true

     # Long running containers
     docker.remains_running = true
  end

end
