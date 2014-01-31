# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'debian-7.2.0'
  config.vm.box_url = 'https://dl.dropboxusercontent.com/s/xymcvez85i29lym/vagrant-debian-wheezy64.box'

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :forwarded_port, guest: 9200, host: 9200
  config.vm.network :forwarded_port, guest: 9201, host: 9201

  config.vm.network :private_network, ip: '10.11.12.13'
  config.vm.synced_folder './', '/home/vagrant/asearcher', nfs: true

  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '1024']
  end
end
