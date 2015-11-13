# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "768"
    vb.gui = true
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_check_update = true

    config.vm.network :forwarded_port, host: 8888, guest: 80
    config.vm.network :forwarded_port, host: 3333, guest: 3306
    config.vm.network "private_network", ip: "192.168.0.100"
    config.vm.synced_folder "./www/", "/var/www/", id: "vagrant-root", type: 'nfs', create: true
  end
  config.vm.provider :aws do |aws, override|
    config.vm.box = "dummy"
    config.vm.synced_folder "./www/", "/var/www/", id: "vagrant-root", type: 'rsync', create: true
    config.vm.synced_folder ".", "/vagrant", type: "rsync",
      rsync__exclude: ".git/", create: true
    aws.ami = "ami-47a23a30"
    aws.region ="eu-west-1"
    aws.access_key_id = ENV['AWS_ACCESS_KEY']
    aws.secret_access_key = ENV['AWS_SECRET_KEY']
    aws.keypair_name = "openeyes_aws"
    aws.security_groups = "openeyes"

    aws.instance_type = "t2.micro"

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "~/.ssh/openeyes.pem"
  end
  
  config.vm.provision "shell",
    inline: "Running install-system.sh",
    inline: "sudo /bin/bash /vagrant/install/install-system.sh",
    inline: "sudo /bin/bash /vagrant/install/install-oe.sh"
end
