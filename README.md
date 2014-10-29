== README

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
 

## Rethinkdb container

Host setup

While the RethinkDB process runs isolated in a Docker container, the RethinkDB data resides on the host’s filesystem, and is made available to the RethinkDB container via Docker’s Data Volume feature.

On the host, create the folder
`/var/lib/rethinkdb/data`

Then, create the RethinkDB container and specify expose the newly-created folder as a Data Volume:

`docker run --name db -d -p 8080:8080 -p 28015:28015 -p 29015:29015 -v /var/lib/rethinkdb/data:/data dockerfile/rethinkdb rethinkdb --bind all --directory /data`




## Getting data into and out of Dockerised RethinkDB

- Start the samba-server container:
`docker start samba-server`

- Connect your local machine to the remote docker host using Samba. 
For OS X, this means opening the Finder and then Go -> Connect to Server

- Start the db_admin container with a link to the rethinkdb container and a --volumes-from
`docker run -i -t --name db_admin --volumes-from db --link db:db wingtags/backup:1.15 /bin/bash`

### Containers

*db* Container running rethinkdb 
*web* RoR app running main site
*api* Node.js app serving mobile API

### Rethinkdb container

docker run 

### Links
web/db
api/db

### Linking containers

docker run -d --name db training/postgres

docker run -d -P --name web --link db:db training/webapp python app.py

# Deployment

## Environment variables

### Rails secret key

config:set wingtags RAILS_SECRET=VALUE1

