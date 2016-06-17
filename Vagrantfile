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
     # Generate and copy your private key into /keys if you want to use your
     # own keys. don't forget to check the correct private_key_path
     #config.ssh.private_key_path = 'keys/id_rsa'
     #config.ssh.forward_agent = true

     # Long running containers
     docker.remains_running = true
  end
end
