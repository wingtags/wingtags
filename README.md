== README

# Vagrant

## Dokku host

cat ~/.ssh/id_rsa.pub | vagrant ssh {machine_id} -c "sudo sshcommand acl-add dokku progrium"

## Set container configuration
sudo iptables -L -n
172.17.0.3
28015
RETHINKDB_DB=WingtagsDevelopment
RETHINKDB_HOST=172.17.0.3
RETHINKDB_PORT=28015
RAILS_SECRET_KEY=
DEVISE_SECRET_KEY=


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