# Wingtags



## Setup

This project requires [Vagrant](www.vagrantup.com) and [VirtualBox](www.virtualbox.org). Ensure both are installed before continuing.

### Initialise the virtual machines

```
$ cd path/to/project
$ vagrant up
```

This command will spin up an Ubuntu VirtualBox VM running [Dokku](). It will also create a Docker container running [RethinkDB]() on the Dokku VM.

#### Configure local hosts file

Add the following to `/etc/hosts`:
```
10.0.0.2        dokku.me
10.0.0.2		wingtags.dokku.me
```

#### Configure Dokku

Find the ID of the Dokku VM:
```
$ vagrant global-status
id       name      provider   state     
----------------------------------------
04bed98  dokku     virtualbox running
7a3379b  rethinkdb docker     preparing
```

Add your public key to Dokku:
```
cat ~/.ssh/id_rsa.pub | vagrant ssh {machine-id} -c "sudo sshcommand acl-add dokku progrium"
```

#### Push the project to Dokku

```
$ git remote add local dokku@dokku.me:wingtags
$ git push master local
```

#### Configure the Wingtags Dokku instance

You need to set five config values on the Wingtags Dokku instance:
RAILS_SECRET_KEY   Key for signing cookies generated by Rails
DEVISE_SECRET_KEY  Key for salting user passwords
RETHINKDB_DB       The name of the RethinkDB database.
RETHINKDB_HOST     IP address of the RethinkDB instance.
RETHINKDB_PORT     The port RethinkDB listens for incoming connections on.

##### RAILS_SECRET_KEY & DEVISE_SECRET_KEY

```
$ cd path/to/project
$ bundle exec rake secret
```

##### RETHINKDB_DB

Either "WingtagsDevelopment" or "Wingtags" (production).

##### RETHINKDB_HOST

Get the internal Docker IP address of the RethinkDB instance:

```
$ vagrant ssh {machine-id}
$ sudo iptables -L -n
Chain DOCKER (1 references)
target     prot opt source               destination
ACCEPT     tcp  --  0.0.0.0/0            172.17.0.6           tcp dpt:8080
ACCEPT     tcp  --  0.0.0.0/0            172.17.0.6           tcp dpt:28015
ACCEPT     tcp  --  0.0.0.0/0            172.17.0.6           tcp dpt:29015
ACCEPT     tcp  --  0.0.0.0/0            172.17.0.8           tcp dpt:5000
```

Note the `destination` IP address corresponding to tcp ports 8080, 28015 and 29015. This is the IP address of the RethinkDB Docker container (172.17.0.6 in the above example).

##### RETHINKDB_PORT

28015, unless you've changed it :P

#### Go!
```
$ vagrant ssh {machine_id}
$ dokku config:set wingtags RAILS_SECRET_KEY=<secret> DEVISE_SECRET_KEY=<secret> RETHINKDB_DB=<db> RETHINKDB_HOST=<host> RETHINKDB_PORT=<port>
```




# Installation

You need to set up two components: the Rails app and the RethinkDB database.

## RethinkDB

This guide assumes you are running OS X and using Homebrew as your package manager. 

1. Update Homebrew
`brew update`

2. Install RethinkDB
`brew install rethinkdb`

3. Load RethinkDB
`launchctl load ~/Library/LaunchAgents/homebrew.mxcl.rethinkdb.plist`

This will instruct **launchd**, the OS X process manager, to load RethinkDB at startup. Data will be stored at `/usr/local/var/rethinkdb` logs at `/usr/local/var/log/rethinkdb.log`. (These values can be changed by editing the `homebrew.mxcl.rethinkdb.plist` file.)

4. Verify RethinkDB is running.
Visit `localhost:8080` in your browser. You should see the RethinkDB admin dashboard. 

## Rails

### Installation

The website is a Rails 4.1 application and requires Ruby 1.9.3 or newer. Ruby 2.1 is preferred, however. 

To install the app, simply clone the project to your machine and run `bundle install` to install the dependencies.

### Configuration

Duplicate the `application.yml.example` file in the ‘config’ folder and delete the `.example` extension so that it is named `application.yml`. This file defines the environment variables and their values that the app requires. The default values for the Development and Test environments should work if you installed RethinkDB and Rails as described above. 

*Do not commit this file to source control.* It contains confidential information (particularly the Rails secret key) that, if made public, would compromise the security of the app.

### Initialisation

From the rails project folder, run `rake db:create` followed by `rake db:seed`. This will create the tables required by the Wingtags project and seed them with a small set of sample data.
