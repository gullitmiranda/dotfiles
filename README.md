# Gullit Miranda dotfiles

## Installation

### Setup dotfiles

```bash
sh -c "`curl -fsSL https://raw.github.com/gullitmiranda/dotfiles/master/install.sh`"
```

### Install dependencies

```shell
# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install brew packages (from Brewfile)
brew bundle
```

## Configure Git

create a local gitconfig file from sample

```shell
cp .config/git/sample.local.gitconfig ~/dotfiles/customs/git/local.gitconfig
# replace global gitconfig link to the new config file
# NOTE: the new config file already include ~/dotfiles/git/config
ln -sf ~/dotfiles/customs/git/local.gitconfig ~/.gitconfig
```

## Mac Update

### System Updates

From the [update-macos-via-cli-with-softwareupdate](https://scott-bollinger.com/update-macos-via-cli-with-softwareupdate) use the command softwareupdate -ia.

```shell
softwareupdate -ia
```

### Mac App Store Updates

From the manage-mac-appstore-apps-with-mas include the command mas upgrade.

```shell
mas upgrade
```

### Brew Updates

Use the brew update, upgrade, and cleanup to install pending updates and upgrades for brew managed apps.

```shell
brew update && brew upgrade && brew cleanup
```

## TODO

- [ ] Use [Scripts to Rule Them All](https://github.blog/2015-06-30-scripts-to-rule-them-all/) pattern to scripts. Examples:
  - <https://github.com/github/scripts-to-rule-them-all>

## Utils Scripts

A collection of utils bash and fish scripts

### CWD

Gets the current working directory

- bash

```bash
# Gets the current working directory - with preventiong of duplicated pwd)
__DIRNAME="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd | head)"
```

- fish

```fish
# Gets the current working directory
set __DIRNAME (realpath (dirname (status filename)))
```

## References

- Mac OS X
  - <https://scott-bollinger.com/macos-update-aio-alias>
  - <https://scott-bollinger.com/update-macos-via-cli-with-softwareupdate>
  - <https://scott-bollinger.com/manage-mac-appstore-apps-with-mas>
