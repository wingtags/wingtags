# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  #config.vm.devine "rethinkdb_data", do |vm|
  #  vm.vm.provider "docker" do |d|
  #    d.vagrant_machine = "dokku"
  #    d.vagrant_vagrantfile = "vagrant/dokku/Vagrantfile"
  #    d.image = "dockerfile/ubuntu"
  #    d.name = "rethinkdb_data"
  #    d.volumes = ["data"]
  #  end
  #end

  config.vm.define "rethinkdb", primary: true do |rethinkdb|
    rethinkdb.vm.provider "docker" do |d|
      d.vagrant_machine = "dokku"
      d.vagrant_vagrantfile = "dokku/Vagrantfile"
      d.build_dir = "."
      d.volumes = ["/rethinkdb_data:/data"]
      d.ports = ["8090:8080", "28015:28015", "29015:29015"]
      d.name = "rethinkdb"
    end
  end
end
