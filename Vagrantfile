# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
# Check for missing plugins
  required_plugins = %w(vagrant-disksize vagrant-hostmanager vagrant-vbguest vagrant-clean)
  plugin_installed = false
  required_plugins.each do |plugin|
    unless Vagrant.has_plugin?(plugin)
      system "vagrant plugin install #{plugin}"
      if Vagrant::Util::Platform.windows?
        system "vagrant plugin install vagrant-winnfsd"  
      end
      plugin_installed = true
    end
  end

  # If new plugins installed, restart Vagrant process
  if plugin_installed === true
    exec "vagrant #{ARGV.join' '}"
  end

 #https://peshmerge.io/how-to-speed-up-vagrant-on-windows-10-using-nfs/
  config.vm.synced_folder ".", "/vagrant", type: "nfs" , mount_options: %w{rw,async,fsc,nolock,vers=3,udp,rsize=32768,wsize=32768,hard,noatime,actimeo=2}
 
 #https://stackoverflow.com/questions/29389116/skip-certificate-validation-on-vagrant-up certificate skipping is required # as AV vendors blocking SSL checks on CLI 
  config.vm.box_download_insecure = true
#https://app.vagrantup.com/notsosecure/boxes/dso-base/versions/0.1  
  config.vm.box = 'notsosecure/dso-base'
#  config.vm.box = 'ubuntu/bionic64'
  config.vm.box_check_update = false
  config.vbguest.auto_update = false
  config.vm.hostname = "devsecops"
  config.vm.network :private_network, ip: '192.168.34.4'
  config.disksize.size = '50GB'
  
  config.vm.provider "virtualbox" do |vb|
    vb.name = 'devsecops'
    vb.memory = 8288
    vb.cpus = 1
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--uartmode1", "disconnected"]
  vb.gui = false
  
  end

  config.vm.provision "shell",privileged: true, inline: <<-SHELL
    #Removing the apt lock
    sudo rm /var/lib/dpkg/lock*

    #Ensuring DNS Server is pointing to 8.8.8.8
    sed -i s'/#prepend domain-name-servers 127.0.0.1/prepend domain-name-servers 8.8.8.8,8.8.4.4/' /etc/dhcp/dhclient.conf
    echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
    apt update -y
    apt install resolvconf -y
    systemctl start resolvconf.service
    systemctl enable resolvconf.service
    systemctl status resolvconf.service
    touch /etc/resolvconf/resolv.conf.d/head
    echo "nameserver 8.8.8.8" | sudo tee /etc/resolvconf/resolv.conf.d/head
    systemctl restart resolvconf.service
  SHELL

  config.vm.provision "file", source: "./README.md", destination: "/home/vagrant/on-prem-lab/"
  config.vm.provision "file", source: "./Vagrantfile", destination: "/home/vagrant/on-prem-lab/"
  config.vm.provision "file", source: "./provisioning", destination: "/home/vagrant/on-prem-lab/"

  config.vm.provision "file", source: "../code", destination: "/home/vagrant/"

  config.vm.provision "shell",privileged: true, inline: <<-SHELL
    
    # Installing and Running mdBook for welcome.local
    export MDBOOK_VERSION=0.4.4
    wget https://github.com/rust-lang/mdBook/releases/download/v${MDBOOK_VERSION}/mdbook-v${MDBOOK_VERSION}-x86_64-unknown-linux-gnu.tar.gz -O - | sudo tar -xz -C /usr/local/bin
    mdbook clean /vagrant/book
    mdbook build /vagrant/book
    cp -r /vagrant/book/book /home/vagrant/
    sudo apt-get install -y python3 python3-pip
    sudo pip3 install ansible==2.9.13
  SHELL

  config.vm.provision "shell",privileged: true,path: './provisioning/openvas/script.sh'

  config.vm.provision "ansible_local" do |ansible|
    ansible.compatibility_mode = '2.0'
    ansible.extra_vars = { ansible_python_interpreter:"/usr/bin/python3" }
    ansible.playbook = "/home/vagrant/on-prem-lab/provisioning/playbook.yml"
    ansible.verbose = true
  end

end