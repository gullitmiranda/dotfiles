# Installation

Installation is automated via `rake` and the `dotfiles` command. To get
started please run:

```bash
sh -c "`curl -fsSL https://raw.github.com/gullitmiranda/dotfiles/master/install.sh`"
```

### Upgrading

Upgrading is easy.

```bash
cd ~/.dotfiles
git pull origin master
rake update
```

