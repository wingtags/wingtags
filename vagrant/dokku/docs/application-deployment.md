# Deploy an App

Now you can deploy apps on your Dokku. Let's deploy the [Heroku Node.js sample app](https://github.com/heroku/node-js-sample). All you have to do is add a remote to name the app. It's created on-the-fly.

```
$ cd node-js-sample
$ git remote add dokku dokku@dokku.me:node-js-app
$ git push dokku master
Counting objects: 296, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (254/254), done.
Writing objects: 100% (296/296), 193.59 KiB, done.
Total 296 (delta 25), reused 276 (delta 13)
-----> Building node-js-app ...
       Node.js app detected
-----> Resolving engine versions

... blah blah blah ...

-----> Application deployed:
       http://node-js-app.dokku.me
```

You're done!

Dokku only supports deploying from its master branch, so if you'd like to deploy a different local branch use: ```git push dokku <local branch>:master```

Right now Buildstep supports buildpacks for Node.js, Ruby, Python, [and more](https://github.com/progrium/buildstep#supported-buildpacks). It's not hard to add more, [go add more](https://github.com/progrium/buildstep#adding-buildpacks)!
Please check the documentation for your particular build pack as you may need to include configuration files (such as a Procfile) in your project root.

## Deploying with private git submodules

Dokku uses git locally (i.e. not a docker image) to build its own copy of your app repo, including submodules. This is done as the `dokku` user. Therefore, in order to deploy private git submodules, you'll need to drop your deploy key in `~dokku/.ssh` and potentially add github.com (or your VCS host key) into `~dokku/.ssh/known_hosts`. A decent test like this should help confirm you've done it correctly.

```
su - dokku
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
ssh -T git@github.com
```

## Specifying a custom buildpack

If buildpack detection isn't working well for you or you want to specify a custom buildpack for one repository you can create & commit a file in the root of your git repository named `.env` containing `export BUILDPACK_URL=<repository>` before pushing. This will tell buildstep to fetch the specified buildpack and use it instead of relying on the built-in buildpacks & their detection methods.

## Default vhost

You might notice the default vhost for Nginx will be one of the apps. If an app doesn't exist, it will use this vhost and it may be confusing for it to go to another app. You can create a default vhost using a configuration under `sites-enabled`. You just have to change one thing in the main nginx.conf:

Swap both conf.d include line and the sites-enabled include line. From:
```
include /etc/nginx/conf.d/*.conf;
include /etc/nginx/sites-enabled/*;
```
to
```
include /etc/nginx/sites-enabled/*;
include /etc/nginx/conf.d/*.conf;
```

Alternatively, you may push an app to your dokku host with a name like "00-default". As long as it lists first in `ls /home/dokku/*/nginx.conf | head`, it will be used as the default nginx vhost.

## Deploying to subdomains

The name of remote repository is used as the name of application to be deployed, as for example above:

    $ git remote add dokku dokku@dokku.me:node-js-app
    $ git push dokku master

Is deployed to,

    remote: -----> Application deployed:
    remote:        http://node-js-app.dokku.me

You can also specify fully qualified names, say `app.dokku.me`, as

    $ git remote add dokku dokku@dokku.me:app.dokku.me
    $ git push dokku master

So, after deployment the application will be available at,

    remote: -----> Application deployed:
    remote:        http://app.dokku.me

This is in particular useful, then you want to deploy to root domain, as

    $ git remote add dokku dokku@dokku.me:dokku.me
    $ git push dokku master

    ... deployment ...

    remote: -----> Application deployed:
    remote:        http://dokku.me

# Zero downtime deploy

Following a deploy Dokku's default behaviour is to switch new traffic over to the new container immediately.

This can be problematic for applications that take some time to boot up and can lead to `502 Bad Gateway` errors.

Dokku provides a way to run a set of checks against the new container, and only switch traffic over if all checks complete successfully.

To specify checks, add a `CHECKS` file to the root of your project directory. This is a text file with one line per check. Empty lines and lines starting with `#` are ignored.

A check is a relative URL and may be followed by expected content from the page, for example:

```
/about      Our Amazing Team
```

Dokku will wait `DOKKU_CHECKS_WAIT` seconds (default: `5`) before running the checks to give server time to start. For shorter/longer wait, change the `DOKKU_CHECKS_WAIT` environment variable.

Dokku will wait `DOKKU_WAIT_TO_RETIRE` seconds (default: `60`) before stopping the old container such that no existing connections to it are dropped.

# Removing a deployed app

SSH onto the server, then execute:

```shell
dokku apps:destroy myapp
```
