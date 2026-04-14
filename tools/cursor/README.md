# Cursor

Multi-profile setup for the [Cursor](https://cursor.sh) editor, managed via `cursor-profile`.

Each profile gets its own `.app` bundle, user data directory, and CLI launcher, while sharing
common config files through symlinks.

---

## How it works

### Profiles

Profiles are defined in [`config.yaml`](../../config.yaml) under `variables.cursor.profiles`:

```yaml
cursor:
  userSettingsLinks:
    keybindings.json: shared/keybindings.json
    settings.json: shared/settings.json
    snippets: shared/snippets

  profiles:
    - name: Work
      default: true # uses native Cursor.app + ~/Library/.../Cursor
      badge_color: "#0066CC"
    - name: Personal
      badge_color: "#CC6600"
```

One profile can be marked as `default: true` — it maps to the native `Cursor.app` and its
standard user data directory (`~/Library/Application Support/Cursor`). All other profiles get
a custom `.app` bundle and an isolated user data directory (`~/Library/.../Cursor{Name}`).

### Links

`userSettingsLinks` defines which files are symlinked from the dotfiles into each profile's
user data directory. The key is the filename inside `User/`, the value is the source path
relative to `tools/cursor/`.

- **`shared/`** — files symlinked identically across all profiles (the default)
- **`profiles/{Name}/`** — files specific to each profile (opt-in via override)

`{name}` in source paths is replaced with the profile name at runtime.

A profile can override or disable individual links:

```yaml
- name: Personal
  userSettingsLinks:
    settings.json: profiles/Personal/settings.json # profile-specific settings
    keybindings.json: profiles/Personal/keybindings.json # profile-specific keybindings
    snippets: false # don't manage snippets for this profile
```

### Auto-import

When `setup` runs and a symlink target doesn't exist yet in dotfiles, but a real file exists
in the user data directory, it is **automatically imported** into dotfiles before the symlink
is created. This is how you migrate an existing Cursor installation into the dotfiles.

---

## Directory structure

```
tools/cursor/
  profiles/
    Work/                 ← profile-specific overrides (when userSettingsLinks is overridden)
    Personal/
      settings.json       ← example: Personal uses its own settings instead of shared
  shared/
    settings.json         ← symlinked into all profiles by default
    keybindings.json      ← symlinked into all profiles
    snippets/             ← symlinked into all profiles
  bin/
    cursor-profile        ← main command (see below)
    cursor-setup          ← thin wrapper: cursor-profile setup --all
    generate-icon.py      ← generates badged .app icons (requires Pillow)
  backup/
    settings.json         ← manual backup reference (not used by scripts)
    extensions.json       ← manual backup reference (not used by scripts)
  dot.yaml                ← rotz install config
```

---

## Commands

### `cursor-profile`

```
cursor-profile list
cursor-profile setup   [<name>|--all] [--force]
cursor-profile bootstrap [<name>|--all] [--force]
cursor-profile add     <name> [--default] [--color=#hex]
cursor-profile rm      <name> [--keep-data]
cursor-profile open    <name> [cursor args...]
```

| Subcommand  | Description                                                                                                                |
| ----------- | -------------------------------------------------------------------------------------------------------------------------- |
| `list`      | Lists all profiles with their config and data dir status                                                                   |
| `setup`     | Creates `.app` bundles + symlinks. Idempotent. Auto-imports existing files.                                                |
| `bootstrap` | Merges `shared/settings.json` into `profiles/{Name}/settings.json`. Useful for seeding a new profile from shared defaults. |
| `add`       | Adds a new profile to `config.yaml` and creates its directory                                                              |
| `rm`        | Removes a profile, its `.app` bundle, launcher, and optionally its user data                                               |
| `open`      | Opens Cursor with a specific profile (used internally by launchers)                                                        |

### `cursor-setup`

Shorthand for `cursor-profile setup --all`. Called automatically by `rotz install tools/cursor`.

### Per-profile launchers

`setup` generates `~/.local/bin/cursor-{slug}` for each profile (e.g. `cursor-work`,
`cursor-personal`). These are thin wrappers around `cursor-profile open {Name}`.

---

## Adding a new profile

```bash
# 1. Add to config and create directory
cursor-profile add Freelance --color=#AA00CC

# 2. Edit profile-specific settings (optional)
$EDITOR tools/cursor/profiles/Freelance/settings.json

# 3. Create .app bundle + symlinks
cursor-profile setup Freelance
```

---

## Changing the default profile

The `default: true` flag determines which profile maps to the native `Cursor.app`. Only one
profile can be default.

To change it, update `config.yaml` manually (move `default: true` to the desired profile) then
migrate the user data directories:

```bash
# Move current default data out of the way
mv ~/Library/Application\ Support/Cursor ~/Library/Application\ Support/Cursor{OldName}

# Move the new default's data into the native location
mv ~/Library/Application\ Support/Cursor{NewName} ~/Library/Application\ Support/Cursor

# Re-run setup
cursor-setup
```

---

## Backup inventory

| What               | Location                                   | In dotfiles?   | Notes                                                                     |
| ------------------ | ------------------------------------------ | -------------- | ------------------------------------------------------------------------- |
| `settings.json`    | `User/settings.json`                       | ✅ symlinked   | `profiles/{Name}/settings.json`                                           |
| `keybindings.json` | `User/keybindings.json`                    | ✅ symlinked   | `shared/keybindings.json`                                                 |
| `snippets/`        | `User/snippets/`                           | ✅ symlinked   | `shared/snippets/`                                                        |
| `.app` bundles     | `/Applications/Cursor{Name}.app`           | ✅ recreated   | Generated by `cursor-profile setup`                                       |
| Launchers          | `~/.local/bin/cursor-{name}`               | ✅ recreated   | Generated by `cursor-profile setup`                                       |
| Extensions         | `~/.cursor/extensions/`                    | ✅ cursor-sync | Auto-generated list on push; auto-installs on pull (default profile only) |
| Extension registry | `~/.cursor/extensions/extensions.json`     | ❌             | Internal Cursor file, not portable                                        |
| Chat history       | `User/globalStorage/`                      | ❌             | AI conversation history lives here                                        |
| Auth / login       | `User/globalStorage/`                      | ❌             | Cursor account session stored here                                        |
| Workspace state    | `User/workspaceStorage/`                   | ❌             | Open tabs, layout, per-project state                                      |
| File history       | `User/History/`                            | ❌             | Local edit history (Timeline feature)                                     |
| MCP config         | `~/.cursor/mcp.json`                       | ✅ cursor-sync | MCP server definitions                                                    |
| Cursor rules       | `~/.cursor/rules/`                         | ✅ cursor-sync | `.mdc` rule files                                                         |
| Skills & commands  | `~/.cursor/skills/`, `~/.cursor/commands/` | ✅ cursor-sync | AI skills and custom commands                                             |
| Agent transcripts  | `~/.cursor/projects/*/agent-transcripts/`  | ✅ cursor-sync | Conversation history with sidebar restore support                         |
| Cursor state       | `~/.cursor/`                               | ❌             | `ide_state.json`, `plans/`, etc. — not synced                             |

> **Note:** Items marked ❌ are not managed by this setup and will need to be reconfigured on a
> new machine. Items marked ✅ cursor-sync are handled by the
> [Cursor Sync extension](#cursor-sync-extension) — see setup instructions below.

---

## Cursor Sync extension

[Cursor Sync](https://open-vsx.org/extension/MarceloBarella/cursor-sync) (`MarceloBarella.cursor-sync`)
handles backup and sync of the items **not managed by dotfiles**: extensions list, MCP config,
AI rules, skills, and agent transcripts. Everything is synced to a single private GitHub Gist.

> **Scope:** cursor-sync only syncs the **default profile**
> (`~/Library/Application Support/Cursor/User/`). With the current setup that means the **Work**
> profile. The Personal profile's settings are managed exclusively by dotfiles.

### Setup

1. Run `rotz install tools/cursor` — this installs the extension automatically via
   `cursor --install-extension MarceloBarella.cursor-sync`
2. Open the Command Palette → **Cursor Sync: Configure GitHub**
3. Create a [GitHub fine-grained token](https://github.com/settings/personal-access-tokens/new)
   with **Account permissions → Gists: Read and write**
4. Paste the token when prompted — it is stored in VS Code SecretStorage, never in settings files

On first use, run **Cursor Sync: Push Now** on the primary machine. On a new machine, configure
the token first, then run **Cursor Sync: Pull Now**.

### Interaction with dotfiles symlinks

`settings.json`, `keybindings.json`, and `snippets/` are included in cursor-sync's default
`enabledPaths`. Since these paths are **symlinks** pointing into the dotfiles repo, a cursor-sync
pull writes through the symlink — effectively modifying the versioned files on disk. This is
intentional: the Gist acts as a secondary backup. If Git and the Gist diverge, commit the
changes to dotfiles after pulling.

### Configuration reference

The following settings are defined in `shared/settings.json` and apply to all profiles:

| Setting                                   | Default | Purpose                                        |
| ----------------------------------------- | ------- | ---------------------------------------------- |
| `cursorSync.schedule.enabled`             | `true`  | Auto-sync every N minutes                      |
| `cursorSync.schedule.intervalMin`         | `30`    | Sync interval in minutes (min 5)               |
| `cursorSync.safeMode`                     | `true`  | Preview changes before a pull overwrites files |
| `cursorSync.syncExtensions.autoInstall`   | `true`  | Install missing extensions on pull             |
| `cursorSync.syncExtensions.autoUninstall` | `false` | Don't remove local extensions not in the Gist  |
