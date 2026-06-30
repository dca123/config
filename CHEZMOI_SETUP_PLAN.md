# Chezmoi Dotfiles Setup Plan

This machine currently has dotfiles tracked directly under `~/.config`. The goal is to migrate to a single chezmoi-managed dotfiles repo that can be shared across three machines:

- personal macOS machine
- work machine
- Linux machine

Use one chezmoi repo.

Suggested remote:

```txt
git@github.com:dca123/config.git
```

## Desired model

Shared configs are managed normally by chezmoi:

```txt
~/.config/nvim
~/.config/kitty
~/.config/starship.toml
~/.config/zsh/.zshenv
~/.config/zsh/.zprofile
~/.config/zsh/.zshrc
```

Machine-specific zsh files are managed as chezmoi templates:

```txt
~/.config/zsh/local.zshenv
~/.config/zsh/local.profile.zsh
~/.config/zsh/local.zsh
```

chezmoi source paths should become:

```txt
~/.local/share/chezmoi/dot_config/zsh/local.zshenv.tmpl
~/.local/share/chezmoi/dot_config/zsh/local.profile.zsh.tmpl
~/.local/share/chezmoi/dot_config/zsh/local.zsh.tmpl
```

The existing zsh structure already supports this. The shared zsh files source the local layer:

```zsh
[[ -f "$ZDOTDIR/local.zshenv" ]] && source "$ZDOTDIR/local.zshenv"
[[ -f "$ZDOTDIR/local.profile.zsh" ]] && source "$ZDOTDIR/local.profile.zsh"
[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh"
```

## What to manage

Track config files you intentionally edit.

Avoid managing ephemeral/generated state (history, caches, sessions, dumps, temp/backup files).

## Machine identity

Use explicit chezmoi data rather than relying only on hostname.

On each machine run:

```bash
chezmoi edit-config
```

Set one of:

```toml
[data]
machine = "personal-mac"
```

```toml
[data]
machine = "work"
```

```toml
[data]
machine = "linux"
```

Templates can then use:

```gotemplate
{{ if eq .machine "work" }}
# work-only config
{{ end }}

{{ if eq .machine "personal-mac" }}
# personal Mac only
{{ end }}

{{ if eq .chezmoi.os "darwin" }}
# macOS-only config
{{ end }}

{{ if eq .chezmoi.os "linux" }}
# Linux-only config
{{ end }}
```

## Initial migration commands

Install chezmoi:

```bash
brew install chezmoi
```

Initialize source repo:

```bash
chezmoi init
```

Add shared zsh files:

```bash
chezmoi add ~/.config/zsh/.zshenv
chezmoi add ~/.config/zsh/.zprofile
chezmoi add ~/.config/zsh/.zshrc
```

Add machine-specific zsh files as templates:

```bash
chezmoi add --template ~/.config/zsh/local.zshenv
chezmoi add --template ~/.config/zsh/local.profile.zsh
chezmoi add --template ~/.config/zsh/local.zsh
```

Add app configs:

```bash
chezmoi add ~/.config/nvim
chezmoi add ~/.config/kitty
chezmoi add ~/.config/starship.toml
```

Set this machine's identity:

```bash
chezmoi edit-config
```

For this machine, likely:

```toml
[data]
machine = "personal-mac"
```

Review before applying:

```bash
chezmoi diff
chezmoi apply
```

Commit and push:

```bash
chezmoi cd
git init
git add .
git commit -m "Initial chezmoi dotfiles"
git remote add origin git@github.com:dca123/config.git
git push -u origin main
```

## Setup on another machine

Install chezmoi, then:

```bash
chezmoi init git@github.com:dca123/config.git
chezmoi edit-config
```

Set the right machine label:

```toml
[data]
machine = "work"
```

or:

```toml
[data]
machine = "linux"
```

Then review and apply:

```bash
chezmoi diff
chezmoi apply
```

## Daily workflow

Edit a managed file:

```bash
chezmoi edit ~/.config/zsh/.zshrc
chezmoi apply
```

Or edit and apply immediately:

```bash
chezmoi edit --apply ~/.config/zsh/.zshrc
```

Commit changes:

```bash
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

## Notes from current files

Current `local.zsh` contains machine-specific setup for:

- OpenCode path and `OPENCODE_ENABLE_EXA`
- `EXA_API_KEY` from macOS Keychain
- LM Studio path
- Go path
- Bun
- Vite+
- opam cached environment
- local development override for `btca`

Current `local.profile.zsh` contains OrbStack integration, which should be macOS-only:

```gotemplate
{{ if eq .chezmoi.os "darwin" }}
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
{{ end }}
```

Current `local.zshenv` sources Cargo env and can probably be shared everywhere:

```zsh
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
```

Kitty config is currently large and mostly default/commented config. Migrate as-is first; optional cleanup can happen later.
