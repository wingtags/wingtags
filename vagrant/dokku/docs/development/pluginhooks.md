# Pluginhooks

[Pluginhooks](https://github.com/progrium/pluginhook) are a good way to jack into existing dokku infrastructure. You can use them to modify the output of various dokku commands or override internal configuration.

Pluginhooks are simply scripts that are executed by the system. You can use any language you want, so long as the script:

- Is executable
- Has the proper language requirements installed

For instance, if you wanted to write a pluginhook in PHP, you would need to have `php` installed and available on the CLI prior to pluginhook invocation.

The following is an example for the `nginx-hostname` pluginhook. It reverses the hostname that is provided to nginx during deploys. If you created an executable file named `nginx-hostname` with the following code in your plugin, it would be invoked by dokku during the normal app deployment process:

```shell
#!/usr/bin/env bash
set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

APP="$1"; SUBDOMAIN="$2"; VHOST="$3"

NEW_SUBDOMAIN=`echo $SUBDOMAIN | rev`
echo "$NEW_SUBDOMAIN.$VHOST"
```

## Available Pluginhooks

There are a number of plugin-related pluginhooks. These can be optionally implemented by plugins and allow integration into the standard dokku plugin setup/backup/teardown process.

The following pluginhooks describe those available to a dokku installation. As well, there is an example for each pluginhook that you can use as templates for your own plugin development.

> The example pluginhook code is not guaranteed to be implemented as in within dokkku, and are merely simplified examples. Please look at the dokku source for larger, more in-depth examples.

### `install`

- Description: Used to setup any files/configuration for a plugin.
- Invoked by: `dokku plugins-install`.
- Arguments: None
- Example:

```shell
#!/usr/bin/env bash
# Sets the hostname of the dokku server
# based on the output of `hostname -f`

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

if [[ ! -f  "$DOKKU_ROOT/HOSTNAME" ]]; then
  hostname -f > $DOKKU_ROOT/HOSTNAME
fi
```

### `dependencies`

- Description: Used to install system-level dependencies. Invoked by `plugins-install-dependencies`.
- Invoked by: `dokku plugins-install-dependencies`
- Arguments: None
- Example:

```shell
#!/usr/bin/env bash
# Installs nginx for the current plugin
# Supports both opensuse and ubuntu

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

case "$DOKKU_DISTRO" in
  ubuntu)
    export DEBIAN_FRONTEND=noninteractive
    apt-get install --force-yes -qq -y nginx
    ;;

  opensuse)
    zypper -q in -y nginx
    ;;
esac
```

### `update`

- Description: Can be used to run plugin updates on a regular interval. You can schedule the invoker in a cron-task to ensure your system gets regular updates.
- Invoked by: `dokku plugins-update`.
- Arguments: None
- Example:

```shell
#!/usr/bin/env bash
# Update the buildstep image from git source

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

cd /root/dokku
sudo BUILD_STACK=true make install
```

### `commands help`

- Description: Used to aggregate all plugin `help` output. Your plugin should implement a `help` command in your `commands` file to take advantage of this pluginhook. This must be implemented inside the `commands` pluginhook file.
- Invoked by: `dokku help`
- Arguments: None
- Example:

```shell
#!/usr/bin/env bash
# Outputs help for the derp plugin

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

case "$1" in
  help | derp:help)
    cat && cat<<EOF
    derp:herp                                       Herps the derp
    derp:serp [file]                                Shows the file's serp
EOF
    ;;

  *)
    exit $DOKKU_NOT_IMPLEMENTED_EXIT
    ;;

esac
```

### `backup-export`

- Description: Used to backup files for a given plugin. If your plugin writes files to disk, this pluginhook should be used to echo out their full paths. Any files listed will be copied by the backup plugin to the backup tar.gz.
- Invoked by: `dokku backup:export`
- Arguments: `$VERSION $DOKKU_ROOT`
- Example:

```shell
#!/usr/bin/env bash
# Echos out the location of every `REDIRECT` file
# that are used by the apps

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

shopt -s nullglob
VERSION="$1"
DOKKU_ROOT="$2"

cat; for i in $DOKKU_ROOT/*/REDIRECT; do echo $i; done
```

### `backup-check`

- Description: Checks that a backup being imported passes sanity checks.
- Invoked by: `dokku backup:import`
- Arguments: `$VERSION $BACKUP_ROOT $DOKKU_ROOT $BACKUP_TMP_DIR/.dokku_backup_apps`
- Example:

```shell
#!/usr/bin/env bash

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

# TODO
```

### `backup-import`

- Description: Allows a plugin to import specific files from a `$BACKUP_ROOT` to the `DOKKU_ROOT` directory.
- Invoked by: `dokku backup:import`
- Arguments: `$VERSION $BACKUP_ROOT $DOKKU_ROOT $BACKUP_TMP_DIR/.dokku_backup_apps`
- Example:

```shell
#!/usr/bin/env bash
# Copies all redirect files from the backup
# into the correct app path.

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

shopt -s nullglob
VERSION="$1"
BACKUP_ROOT="$2"
DOKKU_ROOT="$3"

cd $BACKUP_ROOT
for file in */REDIRECT; do
  cp $file "$DOKKU_ROOT/$file"
done
```

### `pre-build-buildstep`

- Description: Allows you to run commands before the build image is created for a given app. For instance, this can be useful to add env vars to your container. Only applies to applications using buildstep.
- Invoked by: `dokku build`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

# TODO
```

### `post-build-buildstep`

- Description: Allows you to run commands after the build image is create for a given app. Only applies to applications using buildstep.
- Invoked by: `dokku build`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

# TODO
```

### `pre-build-dockerfile`

- Description: Allows you to run commands before the build image is created for a given app. For instance, this can be useful to add env vars to your container. Only applies to applications using a dockerfile.
- Invoked by: `dokku build`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

# TODO
```

### `post-build-dockerfile`

- Description: Allows you to run commands after the build image is create for a given app. Only applies to applications using a dockerfile.
- Invoked by: `dokku build`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

# TODO
```

### `pre-release-buildstep`

- Description: Allows you to run commands before environment variables are set for the release step of the deploy. Only applies to applications using buildstep.
- Invoked by: `dokku release`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash
# Installs the graphicsmagick package into the container

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

source "$(dirname $0)/../common/functions"

dokku_log_info1" Installing GraphicsMagick..."

CMD="cat > gm && \
  dpkg -s graphicsmagick > /dev/null 2>&1 || \
  (apt-get update && apt-get install -y graphicsmagick && apt-get clean)"

ID=$(docker run -i -a stdin $IMAGE /bin/bash -c "$CMD")
test $(docker wait $ID) -eq 0
docker commit $ID $IMAGE > /dev/null
```

### `post-release-buildstep`

- Description: Allows you to run commands after environment variables are set for the release step of the deploy. Only applies to applications using buildstep.
- Invoked by: `dokku release`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash
# Installs a package specified by the `CONTAINER_PACKAGE` env var

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

source "$(dirname $0)/../common/functions"

dokku_log_info1" Installing $CONTAINER_PACKAGE..."

CMD="cat > gm && \
  dpkg -s CONTAINER_PACKAGE > /dev/null 2>&1 || \
  (apt-get update && apt-get install -y CONTAINER_PACKAGE && apt-get clean)"

ID=$(docker run -i -a stdin $IMAGE /bin/bash -c "$CMD")
test $(docker wait $ID) -eq 0
docker commit $ID $IMAGE > /dev/null
```

### `pre-release-dockerfile`

- Description: Allows you to run commands before environment variables are set for the release step of the deploy. Only applies to applications using a dockerfile.
- Invoked by: `dokku release`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

# TODO
```

### `post-release-dockerfile`

- Description: Allows you to run commands after environment variables are set for the release step of the deploy. Only applies to applications using a dockerfile.
- Invoked by: `dokku release`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

# TODO
```

### `check-deploy`

- Description: Allows you to run checks on a deploy before dokku allows the container to handle requests.
- Invoked by: `dokku deploy`
- Arguments: `$CONTAINER_ID $APP $INTERNAL_PORT $INTERNAL_IP_ADDRESS`
- Example:

```shell
#!/usr/bin/env bash
# Disables deploys of containers based on whether the
# `DOKKU_DISABLE_DEPLOY` env var is set to `true` for an app

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

CONTAINERID="$1"; APP="$2"; PORT="$3" ; HOSTNAME="${4:-localhost}"

[[ -f "$DOKKU_ROOT/$APP/ENV" ]] && source $DOKKU_ROOT/$APP/ENV
DOKKU_DISABLE_DEPLOY="${DOKKU_DISABLE_DEPLOY:-false}"

if [[ "$DOKKU_DISABLE_DEPLOY" = "true" ]]; then
  echo -e "\033[31m\033[1mDeploys disabled, sorry.\033[0m"
  exit 1
fi
```

### `pre-deploy`

- Description: Allows the running of code before the container's process is started.
- Invoked by: `dokku deploy`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash
# Runs gulp in our container

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

source "$(dirname $0)/../common/functions"

APP="$1"
IMAGE="dokku/$APP"

dokku_log_info1 "Running gulp"
id=$(docker run -d $IMAGE /bin/bash -c "cd /app && gulp default")
test $(docker wait $id) -eq 0
docker commit $id $IMAGE > /dev/null
dokku_log_info1 "Building UI Complete"
```

### `post-deploy`

- Description: Allows running of commands after a deploy has completed. Dokku core currently uses this to switch traffic on nginx.
- Invoked by: `dokku deploy`
- Arguments: `$APP $INTERNAL_PORT $INTERNAL_IP_ADDRESS`
- Example:

```shell
#!/usr/bin/env bash
# Notify an external service that a successful deploy has occurred.

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

curl "http://httpstat.us/200"
```

### `pre-delete`

- Description: Can be used to run commands before an app is deleted.
- Invoked by: `dokku apps:destroy`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash
# Clears out the gulp asset build cache for applications

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

APP="$1"; IMAGE="dokku/$APP"; GULP_CACHE_DIR="$DOKKU_ROOT/$APP/gulp"

if [[ -d $GULP_CACHE_DIR ]]; then
  docker run --rm -v "$GULP_CACHE_DIR:/gulp" "$IMAGE" find /gulp -depth -mindepth 1 -maxdepth 1 -exec rm -Rf {} \; || true
fi
```

### `post-delete`

- Description: Can be used to run commands after an application is deleted.
- Invoked by: `dokku apps:destroy`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash
# Runs a command to ensure that an app's
# postgres installation is removed

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

APP="$1";

dokku postgres:destroy $APP
```

### `docker-args-build`

- Description:
- Invoked by: `dokku build`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

# TODO
```

### `docker-args-deploy`

- Description:
- Invoked by: `dokku deploy`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

# TODO
```

### `docker-args-run`

- Description:
- Invoked by: `dokku run`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

# TODO
```

### `bind-external-ip`

- Description: Allows you to disable binding to the external box ip
- Invoked by: `dokku deploy`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash
# Force always binding to the docker ip, no matter
# what the settings are for a given app.

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

echo false
```

### `post-domains-update`

- Description: Allows you to run commands once the domain for an application has been updated.
- Invoked by: `dokku domains:add`, `dokku domains:clear`, `dokku domains:remove`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash
# Reloads haproxy for our imaginary haproxy plugin
# that replaces the nginx-vhosts plugin

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

sudo service haproxy reload
```

### `git-pre-pull`

- Description:
- Invoked by: `dokku git-upload-pack`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

# TODO
```

### `git-post-pull`

- Description:
- Invoked by: `dokku git-upload-pack`
- Arguments: `$APP`
- Example:

```shell
#!/usr/bin/env bash

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

# TODO
```

### `nginx-hostname`

- Description: Allows you to customize the hostname for a given application.
- Invoked by: `dokku domains:setup`
- Arguments: `$APP $SUBDOMAIN $VHOST`
- Example:

```shell
#!/usr/bin/env bash
# Reverses the hostname for the application

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

APP="$1"; SUBDOMAIN="$2"; VHOST="$3"

NEW_SUBDOMAIN=`echo $SUBDOMAIN | rev`
echo "$NEW_SUBDOMAIN.$VHOST"
```

### `nginx-pre-reload`

- Description: Run before nginx reloads hosts
- Invoked by: `dokku nginx:build-config`
- Arguments: `$APP $INTERNAL_PORT $INTERNAL_IP_ADDRESS`
- Example:

```shell
#!/usr/bin/env bash
# Runs a check against all nginx conf files
# to ensure they are valid

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

nginx -t
```

### `receive-app`

- Description: Allows you to customize what occurs when an app is received. Normally just triggers an application build.
- Invoked by: `dokku git-hook`, `dokku ps:rebuild`
- Arguments: `$APP $REV`
- Example:

```shell
#!/usr/bin/env bash
# For our imaginary mercurial plugin, triggers a rebuild

set -eo pipefail; [[ $DOKKU_TRACE ]] && set -x

APP="$1"; REV="$2"

dokku hg-build $APP $REV
```
