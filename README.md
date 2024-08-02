# Gullit Miranda dotfiles

## TODO

Project TODOs.

- [ ] Refactor `./install.sh` to work with fish and omf
- [ ] Setup <https://github.com/bashup/.devkit>
- [ ] Replace `customs/git/local.gitconfig` by `git/config`
- [ ] Refactor `./make_links.sh` to show what todo, but don't run, but will work with a `eval`
- [ ] bash/zsh
  - [ ] Fix oh-my-zsh setup
  - [ ] Enable starship
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

Install shell integration - <https://iterm2.com/documentation-shell-integration.html>

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

Follow the instructions from <https://gist.github.com/plembo/2a116930d107a6745f239be9e453953c>

### Enable fish as default shell

Set fish as default shell <https://fishshell.com/docs/current/index.html#default-shell>

```shell
which fish | sudo tee -a /etc/shells
chsh -s $(which fish)
# to revert to bash
which bash | sudo tee -a /etc/shells
chsh -s $(which bash)
```

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

## 1Password SSH Agent

- <https://developer.1password.com/docs/ssh>

### 1Password CLI

First, ensure the 1Password CLI is installed and configured <https://support.1password.com/command-line-getting-started/>

```shell
brew install 1password-cli
```

### Enable 1Password SSH agent

To turn on the [1Password SSH agent](https://developer.1password.com/docs/ssh/get-started#step-3-turn-on-the-1password-ssh-agent)
on 1Password App, access `Settings > Developer` enable the option `Use the SSH agent` and `Integrate with 1Password CLI`

(Optional) Make the agent socket easier to access:

```shell
mkdir -p ~/.ssh/sockets

ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.ssh/sockets/1password-agent.sock
```

### Change the SSH client to use the 1Password agent

Change the SSH client to use the 1Password agent

```shell
mkdir -p ~/.ssh
# configure the SSH client
cat <<EOF | tee -a ~/.ssh/config
Host *
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

EOF

# or you can also set the SSH_AUTH_SOCK environment variable
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
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
git config --show-origin --get-regexp '(user|gpg|ssh|commit|credential|include)'
```

### Git Authentication

#### 1Password SSH with Multiple accounts

First you need to setup the [1password SSH agent](#1password-ssh-agent).

- <https://developer.1password.com/docs/ssh/agent/advanced/#use-multiple-github-accounts>

download ssh public keys from 1password into ~/.ssh/

```shell
# list all ssh keys
op item list --categories "SSH Key"
ID                            TITLE                         VAULT                EDITED
0000004JFGSYAKHH7NVQ9G4B47    GitHub SSH Key Work           Work                 10 months ago
0000004JFGSYAKHH7NVQ9G4B48    GitHub SSH Key Personal       Personal             1 year ago

# download the ssh public key
op read "op://Work/GitHub SSH Key Work/public key" --out-file ~/.ssh/op_Work.pub
op read "op://Personal/GitHub SSH Key Personal/public key" --out-file ~/.ssh/op_Personal.pub

# set the permissions
chmod 600 ~/.ssh/op_*.pub
```

Configure git to rewrite the ssh url to use the 1password agent

```shell
git config --global url."git@github.Work:Work/".insteadOf "https://github.com/Work/"
git config --global url."git@github.com:".insteadOf "https://github.com/"
```

Configure SSH hosts

```shell
cat <<EOF | tee -a ~/.ssh/config
# Work GitHub
Host github.Work
    HostName github.com
    User git
    # this only works with the 1password agent
    IdentityFile ~/.ssh/op_Work.pub
    IdentitiesOnly yes

# Personal GitHub
Host github.com
    HostName github.com
    User git
    # this only works with the 1password agent
    IdentityFile ~/.ssh/op_Personal.pub
    IdentitiesOnly yes

EOF
```

#### Git Credentials with 1Password PAT

##### Create a Personal Access Token

To create a Personal Access Token following the instructions from your provider:

###### Create Github PAT

1. Follow this link to create a Personal Access Token on GitHub: <https://github.com/settings/tokens/new?description=git-credential-1password&expires_in=7776000&scopes=repo,public_repo>.
2. Fill in the required information and click 'Generate token'.
3. [Import the token into 1password](#import-the-pat-into-1password)

> Once you leave or refresh the page, you won't be able to access it again.
> How to use 1password browser extension to auto import the PAT: <https://developer.1password.com/docs/cli/shell-plugins/github/#step-1-create-and-save-a-github-personal-access-token>

###### Create GitLab PAT

1. Follow this link to create a Personal Access Token on GitLab: <https://gitlab.com/-/profile/personal_access_tokens>.
2. Fill in the required information
   - scopes: `read_repository, write_repository`
3. Click 'Create personal access token'
4. [Import the token into 1password](#import-the-pat-into-1password)

> Once you leave or refresh the page, you won't be able to access it again.

##### Import the PAT into 1Password

You can import the Personal Access Token into 1Password using one of the options bellow:

###### Using 1Password App

- Open 1Password.
- Click on the '+' button to create a new item.
- Choose 'Password' as the type.
- Fill in the details, pasting your Personal Access Token into the 'password' field.
- Save the new item.

###### Using 1Password CLI

```shell
op item create \
  --category=Password \
  --title='GitHub PAT git-credential-1password' \
  password[password]='<Your GitHub PAT>'
```

> This item will be saved into default vault. Run `op item create --help` for more info.

##### Set up Git to use 1Password for credentials

Configure Git to use the [`git-credential-1password`](./bin/git-credential-1password) script as the credential helper

```shell
git config --global credential.helper "git-credential-1password 'op://Personal/GitHub PAT git-credential-1password/password'"
git config --global credential.useHttpPath true
```

```properties
# expected .gitconfig
[credential]
  helper = git-credential-1password "op://Personal/GitHub PAT git-credential-1password/password"
  useHttpPath = true
```

> Replace `op://Personal/GitHub PAT git-credential-1password/password` with the name of the 1Password item that contains your personal access token. More info at <https://developer.1password.com/docs/cli/secret-references>

#### Git Crendentials from file

To use multiple accounts on one server (e.g. github) you can force git to put the username on the URL.

```shell
git config --global url."https://username@github.com/".insteadOf "https://github.com/"

# with store --file
echo "https://x-access-token:$GHA_PAT@github.com" > ~/Code/Org/.git-credentials && \
git config --global credential.helper 'store --file ~/Code/Org/.git-credentials'
```

### Git commit signing with 1Password

1. [Sign Git commits with SSH](https://developer.1password.com/docs/ssh/git-commit-signing/)
    - You can get all required configs from "1Password SSH key" > "..." > "Configure Commit Signing..."
    - Save the config on `~/Code/$ORG/.gitconfig`. ex: `pbpaste > ~/Code/$ORG/.gitconfig`
    - Configure git to only use this signin config on repositories from `~/Code/$ORG`

        ```shell
        git config --global includeIf.gitdir:~/Code/$ORG/.path ~/Code/$ORG/.gitconfig
        ```

2. Check the configs:

    ```shell
    git config --show-origin --get-regexp '(user|gpg|ssh|commit|credential|include)'
    ```

3. [Use multiple GitHub accounts](https://developer.1password.com/docs/ssh/agent/advanced/#use-multiple-github-accounts)

References:

- [Get started with 1Password + SSH + Git](https://developer.1password.com/docs/ssh/get-started)
- [Sign Git commits with SSH](https://developer.1password.com/docs/ssh/git-commit-signing)

References to try:
- <https://stackoverflow.com/questions/63307136/git-includeif-not-working-with-git-clone>

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
