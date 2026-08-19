# Git Authentication for Multiple Accounts

Git authentication with multiple GitHub accounts over **HTTPS with `gh` CLI tokens**:

- The [`gh` wrapper](./bin/gh) routes every `gh` command to the correct account per invocation (by repo owner or directory), injecting a fresh keyring token.
- Per-directory git credential helpers (`git-credential-gh-user`) do the same for `git push`/`pull`/`fetch`.
- Commit signing uses local SSH keys exported once from 1Password.

Everything works without the 1Password SSH agent, which can lock on a timer and block AI agents and automation. The legacy SSH approach is documented at the end as a fallback.

## Prerequisites

- `git`, `gh`, `jq`, `yq` (installed by `rotz install tools/git`)
- [1Password CLI](https://developer.1password.com/docs/cli/get-started) — only for exporting signing keys (one-time)

## Setup

1. Authenticate each GitHub account with `gh`:

   ```bash
   gh auth login --hostname github.com --git-protocol https --web
   # repeat for the other account when prompted
   ```

2. Declare accounts in `config.yaml`:

   ```yaml
   variables:
     git:
       accounts:
         - name: personal
           gh_user: your-github-username
           owners: # GitHub orgs/users routed to this account by the gh wrapper
             - your-github-username
           gitdirs:
             - ~/code/personal/
           file: ~/code/personal/.gitconfig
           config:
             user.name: "Your Name"
             user.email: "your@personal.email"
             user.signingkey: ~/.ssh/signing_personal
             commit.gpgsign: "true"
             gpg.format: ssh
         - name: work
           gh_user: your-work-github-username
           owners:
             - your-work-org
             - your-work-github-username
           gitdirs:
             - ~/code/work/
           file: ~/code/work/.gitconfig
           config:
             user.name: "Your Name"
             user.email: "your@work.email"
             user.signingkey: ~/.ssh/signing_work
             commit.gpgsign: "true"
             gpg.format: ssh
   ```

3. Run the setup:

   ```bash
   rotz link tools/git
   rotz install tools/git
   ```

   This links `.gitconfig`, `.gitignore_global`, `bin/gh` and `bin/git-credential-gh-user` into `$HOME`, then runs [`setup.sh`](./setup.sh), which reads `config.yaml` via `yq` and:

   - Writes `~/.gitconfig.local` (global config + one `includeIf.gitdir` per account gitdir)
   - Writes each account gitconfig (`user.*`, signing, credential helper)
   - Generates `~/.ssh/allowed_signers` from the accounts' public keys
   - Optionally downloads SSH keys from 1Password (accounts with an `op:` block)

## How routing works

### `gh` commands — the wrapper

`~/.local/bin/gh` (which precedes homebrew in PATH) wraps the real `gh`. Per invocation, first match wins:

1. `GH_TOKEN`/`GITHUB_TOKEN` already set → pass through (CI, manual override)
2. `gh auth ...` subcommands → pass through (keeps `gh auth status` truthful)
3. Non-github.com host (`--hostname`) → pass through
4. Owner in args (`-R owner/repo`, `--repo=`, GitHub URLs, positional `owner/repo`) → matched against `owners` in `config.yaml`
5. cwd inside an account `gitdir` (longest prefix) → that account
6. No match → active keyring account (default `gh` behavior)

On a match, the wrapper injects a fresh token from `gh auth token --user <gh_user>` into that process only. Stateless — no `gh auth switch`, safe for parallel agents. Without `yq` or `config.yaml` it passes through silently.

Overrides: `GH_ROUTER_CONFIG` (alternate config.yaml), `GH_REAL_BIN` (alternate real gh).

### git push/pull/fetch — credential helpers

The global `~/.gitconfig` defines `gh auth git-credential` as the fallback helper. Each account gitconfig overrides it for `https://github.com` with:

```gitconfig
[credential "https://github.com"]
	helper =
	helper = !~/.local/bin/git-credential-gh-user your-github-username github.com
```

The helper unsets inherited `GH_TOKEN`/`GITHUB_TOKEN` before calling `gh auth token --user <gh_user>`, making Git authentication deterministic for GUI clients (e.g. Fork) launched from a terminal with a token for a different account.

### Commit signing

Signing uses local SSH keys exported once from 1Password, so `ssh-keygen` signs without requiring 1Password unlock:

```bash
op read "op://<vault>/<item>/private key" --account "<account>.1password.com" \
  --out-file ~/.ssh/signing_personal
chmod 600 ~/.ssh/signing_personal
```

> [!NOTE]
> 1Password exports ed25519 keys in PKCS#8 format. If `ssh-keygen -y -f` fails with "invalid format", convert to OpenSSH format using `python3` with the `cryptography` library.

Each account gitconfig points `user.signingkey` at its key file (see the `config.yaml` example above). No `gpg.ssh.program` is needed — git defaults to `ssh-keygen`. The public keys registered on GitHub stay the same, so commit verification keeps working.

## Git config layout

- `~/.gitconfig` → symlink to [`.gitconfig`](./.gitconfig) (global defaults, fallback credential helper, includes `~/.gitconfig.local` last)
- `~/.gitconfig.local` → global `user.*` + `includeIf.gitdir` entries (written by `setup.sh`)
- `~/code/<dir>/.gitconfig` → per-account config (written by `setup.sh`)
- `local/.gitconfig.<name>` → optional symlinks to the account files, for opening them from the repo in the IDE

Repos outside any account gitdir use the global config as fallback.

## Troubleshooting

**Which account will a `gh` call use?**

```bash
gh auth status                     # keyring accounts (never injected by the wrapper)
cd <dir> && gh api user --jq .login  # resolved account for that directory
```

**A private repo returns 404 through the wrapper.** Check that its owner is listed under the right account's `owners` in `config.yaml`.

**Git operations use the wrong account.** Check the effective credential helper for the repo:

```bash
git config --show-origin --get-regexp 'credential\..*\.helper'
```

**Bypass the wrapper once:** call the real binary directly (`/opt/homebrew/bin/gh ...`) or set `GH_TOKEN` explicitly.

## Legacy: SSH with 1Password agent

Previous approach using the 1Password SSH agent for git authentication:

Requires the [1Password SSH agent](https://developer.1password.com/docs/ssh/agent/advanced) enabled and SSH keys stored in 1Password.

1. Configure Git to rewrite repository URLs to SSH:

   ```bash
   git config --file ~/.gitconfig.local url."git@github.com:".insteadOf "https://github.com/"
   # with a custom host for the work account
   git config --file ~/.gitconfig.local url."git@github.work.example.com:your-work-org".insteadOf "https://github.com/your-work-org"
   ```

2. Point each account gitconfig at its key:

   ```bash
   git config --file ~/code/personal/.gitconfig \
     core.sshCommand "ssh -i ~/.ssh/op_personal_github.pub"

   git config --file ~/code/work/.gitconfig \
     core.sshCommand "ssh -i ~/.ssh/op_work_github.pub"
   ```

3. Configure `~/.ssh/config` with the 1Password agent and per-host keys:

   ```ssh-config
   Host *
     IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

   Host github.com
     HostName github.com
     User git
     IdentityFile ~/.ssh/op_personal_github.pub
     IdentitiesOnly yes

   Host github.work.example.com
     HostName github.com
     User git
     IdentityFile ~/.ssh/op_work_github.pub
     IdentitiesOnly yes
   ```

4. Test:

   ```bash
   ssh -T git@github.com -i ~/.ssh/op_personal_github.pub
   # Hi your-username! You've successfully authenticated, but GitHub does not provide shell access.
   ```

To list keys registered with the agent:

```bash
env SSH_AUTH_SOCK=~/.1password/agent.sock ssh-add -l
```

> Only keys from the `Personal`, `Private`, or `Employee` vaults are exposed by default; see [1Password SSH Agent Configuration](https://developer.1password.com/docs/ssh/agent/config) to expose other vaults.
