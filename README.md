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
brew install
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

## References

- Mac OS X
  - <https://scott-bollinger.com/macos-update-aio-alias>
  - <https://scott-bollinger.com/update-macos-via-cli-with-softwareupdate>
  - <https://scott-bollinger.com/manage-mac-appstore-apps-with-mas>
