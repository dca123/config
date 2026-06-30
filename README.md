# Devinda's dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Machines

This repo is intended for three machine contexts:

- `personal-mac`
- `work`
- `linux`

Each machine must set a local chezmoi data value:

```bash
chezmoi edit-config
```

Example:

```toml
[data]
machine = "personal-mac"
```

Templates can branch on `.machine` and `.chezmoi.os`.

## Managed shared config

```txt
~/.config/nvim
~/.config/kitty
~/.config/starship.toml
~/.config/zsh/.zshenv
~/.config/zsh/.zprofile
~/.config/zsh/.zshrc
```

## Managed machine-specific zsh templates

```txt
~/.config/zsh/local.zshenv
~/.config/zsh/local.profile.zsh
~/.config/zsh/local.zsh
```

Source templates:

```txt
dot_config/zsh/local.zshenv.tmpl
dot_config/zsh/local.profile.zsh.tmpl
dot_config/zsh/local.zsh.tmpl
```

## What to manage

Track config files you intentionally edit.

Avoid managing ephemeral/generated state (history, caches, sessions, dumps, temp/backup files).

## Setup on a new machine

```bash
chezmoi init git@github.com:dca123/dotfiles.git
chezmoi edit-config
chezmoi diff
chezmoi apply
```

Set the appropriate `[data] machine = "..."` before applying.

## Pi setup

chezmoi bootstraps Pi by cloning `git@github.com:dca123/pi-config.git` into `~/.pi/agent`, installing `@earendil-works/pi-coding-agent@0.79.8`, creating `settings.json` only if it is missing, installing local extension dependencies, and linking Plannotator skills from `~/Projects/plannotator`.

Machine-local Pi data is ignored: auth, trust, sessions, caches, package clone caches, debug logs, node_modules, build output, and pi-rewind shadow git state.

Reproduction gates: `~/.pi/agent` must be committed and pushed to `git@github.com:dca123/pi-config.git` before another machine can clone the Pi setup. `~/Projects/pi-context`, `~/Projects/pi-context-prune`, and `~/Projects/plannotator` have local changes or commits that are not represented by the externals' remotes, so those changes will not reproduce elsewhere until they are pushed or packaged. `night-man` has no configured remote, so `/day-man review` needs a manual `~/Projects/night-man` checkout if you want that review flow.

## Daily workflow

```bash
chezmoi edit --apply ~/.config/zsh/.zshrc
chezmoi cd
git status
git add .
git commit -m "Update dotfiles"
git push
```

Update another machine:

```bash
chezmoi update
```
