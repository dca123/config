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
