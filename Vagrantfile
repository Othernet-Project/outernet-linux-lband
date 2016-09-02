# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
cd /vagrant
/vagrant/installer.sh quick
SCRIPT

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--usb", "on"]
        vb.customize ["modifyvm", :id, "--usbehci", "on"]
        vb.customize ["usbfilter", "add", "0",
                      "--target", :id,
                      "--name", "RTL-SDR USB dongle",
                      "--vendorid", "0bda",
                      "--productid", "2838"]
    end
    config.vm.provision "shell", inline: $script
end
