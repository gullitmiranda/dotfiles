# Git Authentication for Multiple Accounts

This guide covers git authentication with multiple GitHub accounts. The recommended approach uses **HTTPS with `gh` CLI tokens** routed per directory via `mise`, which works independently of 1Password lock state. The legacy SSH-based approach using 1Password agent is documented as a fallback.

## Prerequisites

- [1Password CLI](https://developer.1password.com/docs/cli/get-started)
- [1Password Desktop SSH Agent Enabled](https://developer.1password.com/docs/ssh/agent/advanced)

## Setup

### Enable the 1Password SSH Agent

1. Open 1Password and go to `Preferences > Developer`.
2. Enable the `SSH Agent` option.
3. Add your SSH keys to 1Password, ensuring they are marked as `SSH keys`.

### Run the setup script

```shell
rotz link tools/git
rotz install tools/git
```

The `rotz install` command will:

- Create the `~/.dotfiles/local/gitconfig.json` file with the git config variables from `config.yaml`
- Run the `tools/git/config.fish` script to configure git and the 1Password SSH agent

> [!WARNING]
> Only SSH Keys from the `Personal`, `Private`, or `Employee` vaults are available in the SSH Agent by default.
> If you need to use a different vault, see [Configure 1Password Agent](#configure-1password-agent) section.

### Optional Steps

Most of the steps below are already done by the `rotz install` command, but you can follow them to understand the process and make any changes you need.

#### Configure 1Password Agent

If you want to use the 1Password agent for other purposes like SSH and need to configure the agent to use the SSH keys (other than the default ones: [Personal](https://support.1password.com/1password-glossary/#personal-vault), [Private](https://support.1password.com/1password-glossary/#private-vault), or [Employee](https://support.1password.com/1password-glossary/#employee-vault)), you can create or edit the `~/.config/1Password/ssh/agent.toml` file to configure the 1Password agent:

```toml
[[ssh-keys]]
vault = "Personal"
account = "my.1password.com"

[[ssh-keys]]
vault = "Another Vault"
account = "my.1password.com"

[[ssh-keys]]
vault = "Employee"
account = "work.1password.com"
```

> See [1Password SSH Agent Configuration](https://developer.1password.com/docs/ssh/agent/config) for more information.

#### Configure Your SSH Client

Edit your `~/.ssh/config` file to use the 1Password SSH agent and specify custom commands for different keys:

```ssh-config
Host *
	IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Include 1Password SSH Bookmarks ssh config
# - https://developer.1password.com/docs/ssh/bookmarks
Include ~/.ssh/1Password/config

# Personal GitHub
Host github.com
	HostName github.com
	User git
	IdentityFile ~/.ssh/op_personal_github.pub
	IdentitiesOnly yes

# Work GitHub
Host github.cloudwalk.network
	HostName github.com
	User git
	IdentityFile ~/.ssh/op_cloudwalk_github.pub
	IdentitiesOnly yes
```

- `IdentityAgent` points to the 1Password SSH agent socket.
- `IdentityFile` specifies the key to use for each host.

#### Link 1Password files

For standard purposes, link the 1Password SSH agent and config files to `~/.1password`:

```bash
mkdir -p ~/.1password
ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock
ln -s ~/.config/1Password/ssh/agent.toml ~/.1password/agent.toml
```

#### Git config location (originals, not symlinks)

- `includeIf` in `local/.gitconfig.local` points to the original config files: `~/Code/.gitconfig` (personal) and `~/Code/CloudWalk/.gitconfig` (work).
- Repos outside `~/Code/` (e.g. `~/.dotfiles`) use the personal config from `~/Code/.gitconfig` as fallback.
- The symlinks under `local/` (e.g. `local/.gitconfig.personal` → `~/Code/.gitconfig`) are optional, only to open those files from the repo in the IDE.

## Manual Setup

> [!NOTE]
> You do not need to perform these steps if you have already run the installation script.
> They are more for documentation and troubleshooting purposes.

### Install Dependencies

```bash
brew install --quiet git gh
brew install --quiet --cask 1password-cli
```

### Download the Public Key from 1Password

To set specific keys for different hosts to SSH, download the public key from 1Password. You can do this by:

- In your 1Password app, select the `Download` button on the `Public key` field of the SSH item.
- Use the `op` (1Password CLI) to download the public key:

  ```bash
  # for personal account
  op item list --categories "SSH Key" --account "my.1password.com"
  op read --account "my.1password.com" "op://Personal/GitHub SSH Key Personal/public key" --out-file ~/.ssh/op_personal_github.pub

  # for work account
  op item list --categories "SSH Key" --account "cloudwalk.1password.com"
  op read --account "cloudwalk.1password.com" "op://Employee/GitHub SSH Key CloudWalk/public key" --out-file ~/.ssh/op_cloudwalk_github.pub

  # fix the permissions
  chmod 600 ~/.ssh/op_*.pub
  ```

### Test Your SSH Configuration

Ensure that the SSH keys are working:

Test the personal key:

```bash
$ ssh -T git@github.com -i ~/.ssh/op_personal_github.pub
Hi gullitmiranda! You've successfully authenticated, but GitHub does not provide shell access.
```

Test the work key with the default `github.com` host:

```bash
$ ssh -T git@github.com -i ~/.ssh/op_cloudwalk_github.pub
Hi gullit-work! You've successfully authenticated, but GitHub does not provide shell access.
```

Or using the custom host:

```bash
$ ssh -T git@github.cloudwalk.network -i ~/.ssh/op_cloudwalk_github.pub
Hi gullit-work! You've successfully authenticated, but GitHub does not provide shell access.
```

> **Reference:** [1Password SSH Agent Advanced Usage](https://developer.1password.com/docs/ssh/agent/advanced/#use-multiple-github-accounts)

### Configure Git

#### HTTPS with `gh` credential helper (recommended)

Uses HTTPS for all GitHub operations, authenticated via `gh` CLI tokens stored in the system keyring. This avoids dependency on the 1Password SSH agent, which can lock on a timer (e.g. every 5 minutes with corporate policies) and block AI agents and automation.

1. Authenticate with `gh` for each account:

```bash
gh auth login --hostname github.com --git-protocol https --web
# repeat and login with the other account when prompted
```

2. Force HTTPS for GitHub in `~/.gitconfig.local`:

```gitconfig
; Force HTTPS for GitHub to avoid dependency on 1Password SSH agent,
; which locks every 5 min (corporate policy) and blocks AI agents.
; Auth is handled by `gh auth git-credential` configured in ~/.gitconfig.
[url "https://github.com/"]
	insteadOf = git@github.com:
```

3. Route the correct `gh` account per directory using [mise](https://mise.jdx.dev/) `[env]`:

```toml
# ~/.config/mise/config.toml (global default — personal account)
[env]
GH_TOKEN = "{{ exec(command='gh auth token --user <personal-user>') }}"
```

```toml
# ~/Code/Work/.mise.toml (work account override)
[env]
GH_TOKEN = "{{ exec(command='gh auth token --user <work-user>') }}"
```

mise resolves config hierarchically, so any subdirectory inherits the closest parent's `GH_TOKEN`. The global config covers `/tmp`, `~`, `~/.dotfiles`, etc. The work override only applies inside the work directory. This affects all `gh` commands (`gh pr create`, `gh issue list`, etc.), not just git push/pull.

#### Commit signing with local SSH keys

Uses the same SSH key pair from 1Password, exported once to disk, so `ssh-keygen` can sign commits without requiring 1Password unlock.

1. Export private keys from 1Password (one-time):

```bash
op read "op://<vault>/<item-name>/private key" \
  --account "<account>.1password.com" --out-file ~/.ssh/signing_work
op read "op://<vault>/<item-name>/private key" \
  --account "<account>.1password.com" --out-file ~/.ssh/signing_personal
chmod 600 ~/.ssh/signing_work ~/.ssh/signing_personal
```

> [!NOTE]
> 1Password exports ed25519 keys in PKCS#8 format. If `ssh-keygen -y -f` fails with "invalid format", convert to OpenSSH format using `python3` with the `cryptography` library.

2. Point `user.signingkey` to the local key file in each gitconfig:

```gitconfig
# ~/Code/Work/.gitconfig (work)
[user]
	signingkey = ~/.ssh/signing_work
[commit]
	gpgsign = true
[gpg]
	format = ssh
```

```gitconfig
# ~/Code/.gitconfig (personal)
[user]
	signingkey = ~/.ssh/signing_personal
[commit]
	gpgsign = true
[gpg]
	format = ssh
```

No `gpg.ssh.program` is needed — git defaults to `ssh-keygen`, which reads the key file directly. The public keys registered on GitHub remain the same, so commit verification continues to work.

#### SSH with 1Password (legacy)

<details>
<summary>Previous approach using 1Password SSH agent for git authentication</summary>

1. Configure Git to rewrite the repository URLs to use the SSH protocol:

```bash
git config --file ~/.gitconfig.local url."git@github.com:".insteadOf "https://github.com/"
# if you want to use a custom host for the work account
git config --file ~/.gitconfig.local url."git@github.cloudwalk.network:cloudwalk".insteadOf "https://github.com/cloudwalk"
```

> Using the `~/.gitconfig.local` file because we don't want to override the global config file that is a link to this [.gitconfig](./.gitconfig).

2. Specify a custom SSH command for each git config file:

```bash
git config --file ~/Code/.gitconfig \
  core.sshCommand "ssh -i ~/.ssh/op_personal_github.pub"

git config --file ~/Code/CloudWalk/.gitconfig \
  core.sshCommand "ssh -i ~/.ssh/op_cloudwalk_github.pub"
```

> [!NOTE]
> You will need the `includeIf` directive in your `.gitconfig` already configured to use split config files for different projects.

</details>

## Troubleshooting

### Check Your SSH Keys

After configuring your SSH setup, verify the SSH keys registered with the 1Password SSH agent by running:

```bash
env SSH_AUTH_SOCK=~/.1password/agent.sock ssh-add -l
```

This command lists the keys that the SSH agent is currently managing.

> If your keys are not listed, ensure that the `SSH_AUTH_SOCK` environment variable is set correctly. This environment variable is crucial because it allows command-line tools like `ssh-add` to locate the SSH agent socket.
> While the `IdentityAgent` directive in your SSH configuration file is used for SSH connections, `SSH_AUTH_SOCK` ensures that all tools and applications that use SSH can find the agent socket consistently.
> This project already sets it in your shell configuration files, see [../shells/tools/op](../shells/tools/op) folder.
