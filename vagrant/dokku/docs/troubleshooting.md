## Troubleshooting

__Symptom:__ I deployed my app but I am getting the default nginx page

__Solution:__

Most of the time it's caused by some defaults newer versions of nginx set. To make sure that's the issue you're having run the following:

```
root@dockerapps:/home/git# nginx
nginx: [emerg] could not build the server_names_hash, you should increase server_names_hash_bucket_size: 32
```

If you get a similar error just edit __/etc/nginx/nginx.conf__ and add the following line to your http section:

```
http {
    (... existing content ...)
    server_names_hash_bucket_size 64;
    (...)
}
```

Note that the `server_names_hash_bucket_size` setting defines the maximum domain name length.
A value of 64 would allow domains with up to 64 characters. Set it to 128 if you need longer ones.

Save the file and try stopping nginx and starting it again:

```
root@dockerapps:~/dokku/buildstep# /etc/init.d/nginx stop
 * Stopping nginx nginx                                        [ OK ]
root@dockerapps:~/dokku/buildstep# /etc/init.d/nginx start
 * Starting nginx nginx                                        [ OK ]
```

***

__Symptom:__ I want to deploy my app, but while pushing I get the following error

    ! [remote rejected] master -> master (pre-receive hook declined)

__Solution:__

The `remote rejected` error does not give enough information. Anything could have failed.

To enable dokku tracing, simply run the following command:

    # Since 0.3.9
    dokku trace

In versions older than 0.3.9, you can create a `/home/dokku/dokkurc` file containing the following :

    export DOKKU_TRACE=1

This will trace all of dokku's activity. If this does not help you, create a [gist](https://gist.github.com) containing the full log, and create an issue.

***

__Symptom:__ I get the aforementioned error in the build phase (after turning on dokku tracing)

  Most errors that happen in this phase are due to transient network issues (either locally or remotely) buildpack bugs.

__Solution (Less solution, more helpful troubleshooting steps):__

  Find the failed phase's container image (*077581956a92* in this example)

    ```
    root@dokku:~# docker ps -a  | grep builder
    94d9515e6d93        077581956a92                "/build/builder"       29 minutes ago      Exited (0) 25 minutes ago                       cocky_bell
    ```

  Start a new container with the failed image and poke around (i.e. ensure you can access the internet from within the container or attempt the failed command, if known)

    ```
    root@dokku:~# docker run -ti 077581956a92 /bin/bash
    root@9763ab86e1b4:/# curl -s -S icanhazip.com
    192.168.0.1
    curl http://s3pository.heroku.com/node/v0.10.30/node-v0.10.30-linux-x64.tar.gz -o node-v0.10.30-linux-x64.tar.gz
    tar tzf node-v0.10.30-linux-x64.tar.gz
    ...
    ```

  Sometimes (especially on DO) deploying again seems to get past these seemingly transient issues
  Additionally we've seen issues if changing networks that have different DNS resolvers. In this case, you can run the following to update your resolv.conf

  ```
  root@dokku:~# resolvconf -u
  ```

Please see https://github.com/progrium/dokku/issues/841 and https://github.com/progrium/dokku/issues/649

***

__Symptom:__ I want to deploy my app but I am getting asked for the password of the git user and the error message

    fatal: 'NAME' does not appear to be a git repository
    fatal: Could not read from remote repository.

__Solution:__

You get asked for a password because your ssh secret key can't be found. This may happen if the private key corresponding to the public key you added with `sshcommand acl-add` is not located in the default location `~/.ssh/id_rsa`.

You have to point ssh to the correct secret key for your domain name. Add the following to your `~/.ssh/config`:

    Host DOKKU_HOSTNAME
      IdentityFile "~/.ssh/KEYNAME"

Also see [issue #116](https://github.com/progrium/dokku/issues/116)

***

__Symptom:__ I want to deploy my nodejs app on dokku and use a postinstall script within the package.json but I keep getting this error:

    npm WARN cannot run in wd app@1.0.0 echo blah (wd=/build/app)

__Solution:__

This is a permissions problem as dokku (buildstep) uses a root account for running the application. (This may change please see this thread: https://github.com/progrium/buildstep/pull/42).

To allow npm to work as root account one must set the configuration option of ```unsafe-perm``` to true. There are many ways to set this configuration option but the one I've found works most consistently with the heroku-nodejs-buildpack is as a .npmrc file. The file should contain

```
unsafe-perm = true
```

Note that this is NOT required on heroku as heroku does not use a root account for running the application.

Please see https://github.com/progrium/dokku/issues/420 and https://github.com/heroku/heroku-buildpack-nodejs/issues/92.

***

__Symptom:__ I successfully deployed my application with no deployment errors and receiving Bad Gateway when attempting to access the application

__Solution:__

In many cases the application will require the a `process.env.PORT` port opposed to a specified port.

When specifying your port you may want to use something similar to:

    var port = process.env.PORT || 3000

Please see https://github.com/progrium/dokku/issues/282

