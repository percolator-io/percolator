# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'debian-7.2.0'
  config.vm.box_url = 'https://dl.dropboxusercontent.com/s/xymcvez85i29lym/vagrant-debian-wheezy64.box'

  config.vm.network :forwarded_port, guest: 9292, host: 9292
  config.vm.network :private_network, ip: '10.11.12.13'
  config.vm.synced_folder './', '/home/vagrant/project', nfs: true

  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '512']
  end
end
