# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.define "wingtags", primary: true do |vm|
    vm.vm.provider "docker" do |d|
      #d.vagrant_machine = "dokku"
      #d.vagrant_vagrantfile = "dokku/Vagrantfile"
      d.build_dir = "."
      #d.volumes = ["/rethinkdb_data:/data"]
      #d.ports = ["3000:3000"]
      d.name = "wingtags"
    end
  end
end
