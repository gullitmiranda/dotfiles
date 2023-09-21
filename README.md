# Gullit Miranda dotfiles

## TODO

Project TODOs.

- [ ] Refactor `./install.sh` to work with fish and omf
- [ ] Setup https://github.com/bashup/.devkit
- [ ] Replace `customs/git/local.gitconfig` by `git/config`
- [ ] Refactor `./make_links.sh` to show what todo, but don't run, but will work with a `eval`
- [ ] bash/zsh
  - [ ] Fix oh-my-zsh setup
  - [ ] Enable startship
- [ ] Use [Scripts to Rule Them All](https://github.blog/2015-06-30-scripts-to-rule-them-all/) pattern to scripts. Examples:
  - <https://github.com/github/scripts-to-rule-them-all>
- [ ] Try to customize [`$fisher_path`](https://github.com/jorgebucaran/fisher/issues/640)
- [ ] Make sure the directory `~/.ssh/sockets` is created

## Installation

### Install dependencies

```shell
# install Xcode cli tools
xcode-select --install
# if --install don't work, reset the cli path and try again
# sudo xcode-select --reset

# install brew from https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install new terminal
brew install --cask iterm2
```

## Update system bash

On MacOS the buid-in bash is very outdated, so update and change the default bash.

```shell
brew install --bash --bash-completion
bash
# You need to start a new session to use the new bash
```

> macOS 13.5.2 (22G91) has `GNU bash, version 3.2.57(1)-release (arm64-apple-darwin22)`
> The latest versions was `GNU bash, version 5.2.15(1)-release (aarch64-apple-darwin22.1.0)`

### Setup dotfiles

Clone the repository

```bash
export DOTFILES_DIR=~/dotfiles
git clone https://github.com/gullitmiranda/dotfiles "$DOTFILES_DIR"
cd "$DOTFILES_DIR"
```

Create default synlinks:

```shell
./make_links.sh
```

### brew bundle

Bundle brew dependencies (brew, cask and mas)

```shell
# install brew core packages
brew bundle --file=Brewfile --verbose
```

> TROUBLESHOOTING: If you receive the error `Error: It seems there is already an App at ...`, manually install the package with [`--force`](https://github.com/Homebrew/homebrew-cask/issues/46412) and try again.

> [`mas`](https://github.com/mas-cli/mas) is a Mac App Store command-line interfac

Install shell integration - https://iterm2.com/documentation-shell-integration.html

```shell
# bash
curl -L https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash
# fish
curl -L https://iterm2.com/shell_integration/fish -o ~/.iterm2_shell_integration.fish
# zsh
curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
```

> dotfiles already load iterm2 shell integrations if the file `$HOME/.iterm2_shell_integration.$SHELL` is found

## fish

> NOTE: fish is installed on `brew bundle` command

### oh-my-fish

Install [omf](https://github.com/oh-my-fish/oh-my-fish)

```shell
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
```

### fisher

Install [fisher](https://github.com/jorgebucaran/fisher) and plugins

```shell
# Install fisher cli
echo "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; and fisher install jorgebucaran/fisher" | fish

# Force fisher plugins install:
fisher list | fisher install
```

### Enable fish as default shell only on iTerm

To set Fish as the default shell on iTerm2, follow these steps:

1. Install Fish shell if you haven't already. You can download it from the official website or use a package manager like Homebrew.

2. Open iTerm2.

3. Go to the "iTerm2" menu and select "Preferences" or press `⌘` + `,`.

4. In the Preferences window, click on the "Profiles" tab.

5. Select the profile you want to use Fish as the default shell for or create a new profile.

6. In the "Command" section, select the option "Custom Shell" and enter `/usr/local/bin/fish` or `/opt/homebrew/bin/brew` (on MacOS M1/M2) as the command. Note that the path might be different depending on your Fish shell installation location.

7. Click "OK" to save the profile.

8. Open a new iTerm2 tab for the changes to take effect.

Now, whenever you open iTerm2 or create a new tab, Fish shell will be used as the default shell for that profile.

#### Changing the default terminal shell in vscode

Follow the instructions from https://gist.github.com/plembo/2a116930d107a6745f239be9e453953c

### Enable fish as default shell

Set fish as default shell https://fishshell.com/docs/current/index.html#default-shell

```shell
which fish | sudo tee -a /etc/shells
chsh -s $(which fish)
# to revert to bash
which bash | sudo tee -a /etc/shells
chsh -s $(which bash)
````

## asdf

Install asdf plugins

```shell
asdf plugin add aws-vault
asdf plugin add awscli
asdf plugin add direnv
asdf plugin add elixir
asdf plugin add erlang
asdf plugin add golang
asdf plugin add gomplate
asdf plugin add krew
asdf plugin add kubergrunt
asdf plugin add nodejs
asdf plugin add pnpm
asdf plugin add ruby
asdf plugin add terragrunt
```

Install dependencies

```shell
asdf install
```

## Git

### Setup Git configs

Create a local git config file from the sample. This will make sure that custom configs (probably with sensitive data) aren't commited

```shell
cp .config/git/sample.local.gitconfig ~/.gitconfig
```

Set your user name and email:

```shell
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

How to check if all git config files are loaded

```shell
git config --get-regexp '(user|gpg|ssh|commit)'
```

### Git SSH and commit signing with 1Password

1. [Turn on the 1Password SSH agent](https://developer.1password.com/docs/ssh/get-started/#step-3-turn-on-the-1password-ssh-agent)

    On `1Password Settings > Developer` enable the option `Use the SSH agent` and `Integrate with 1Password CLI`

2. [Configure your SSH or Git client](https://developer.1password.com/docs/ssh/get-started/#step-4-configure-your-ssh-or-git-client)

    ```shell
    mkdir ~/.ssh/

    cat configs/ssh-config | tee -a ~/.ssh/config
    ```

3. [Sign Git commits with SSH](https://developer.1password.com/docs/ssh/git-commit-signing/)
    - You can get all required configs from "1Password SSH key" > "..." > "Configure Commit Signing..."
    - Save the config on `~/Code/$ORG/.gitconfig`. ex: `pbpaste > ~/Code/$ORG/.gitconfig`
    - Configure git to only use this signin config on repositories from `~/Code/$ORG`

        ```shell
        git config --global includeIf.gitdir:~/Code/$ORG/.path ~/Code/$ORG/.gitconfig
        ```

4. Check the configs:

    ```shell
    git config --get-regexp '(user|gpg|ssh|commit)'
    ```

References:
- [Get started with 1Password + SSH + Git](https://developer.1password.com/docs/ssh/get-started)
- [Sign Git commits with SSH](https://developer.1password.com/docs/ssh/git-commit-signing)

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

## Utils Scripts

A collection of utils bash and fish scripts

### CWD

Gets the current working directory

- bash

```bash
# bash directory helpers (with pwd duplication prevention)
__CWD="$(dirname "${BASH_SOURCE[0]:-$0}")"
__DIRNAME="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd)"
__ROOT="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/../.." &>/dev/null && pwd)"
__RELATIVE="$(echo $__DIRNAME | sed -e "s#$__ROOT/##g")"
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
