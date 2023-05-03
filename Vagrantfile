# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|

    config.vm.box = "bento/ubuntu-22.04"
    config.vm.hostname = "quic"
    config.vm.define "quic"

    config.vm.network :forwarded_port, guest: 22, host: 2303, id: 'ssh'
    config.vm.network :forwarded_port, guest: 80, host: 8080, id: 'http'

    # config.vm.synced_folder "../data", "/vagrant_data"
  
    # config.vm.provision "shell", path: "scripts/install-quic.sh", privileged: false
  end