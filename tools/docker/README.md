# Docker

## Docker on Mac with Colima

Install docker and colima (docker desktop alternative) and its dependencies.

```sh
brew install docker docker-buildx qemu colima
```

Configure docker to load plugins:

```shell
jq '.cliPluginsExtraDirs = ["/opt/homebrew/lib/docker/cli-plugins"]' ~/.docker/config.json > ~/.docker/config.tmp \
  && mv ~/.docker/config.tmp ~/.docker/config.json
```

### Start Colima

When working with Apple Silicon (M1, M2, etc.), you may need to start Colima with the following command:

```sh
# WARNING: the --save-config will override the profile config file
colima start \
  --profile default \
  --activate false \
  --mount-inotify \
  --ssh-agent \
  --vm-type vz \
  --vz-rosetta \
  --memory 4 \
  --save-config \
  --verbose
```

Or, you can use the following command to start Colima with the default profile:

```sh
colima start
```

## Docker on Linux

```sh
sudo apt-get install -y docker.io
```
