# dotfiles

Managed with [chezmoi](https://chezmoi.io).

`.chezmoiroot` points chezmoi at `home/`, so everything under it is source state and everything at the repo root (this README, `.gitignore`, CI config) is simply outside chezmoi's view — no ignore rules needed to keep them out of `$HOME`.

Source file names encode the target path and permissions: `home/dot_config/` → `~/.config/`, `private_` → mode 0600/0700.

## Daily use

```sh
chezmoi diff          # what would change in $HOME
chezmoi apply         # repo → live
chezmoi re-add        # live → repo, after tweaking a config in an app's UI
chezmoi edit ~/.config/fish/config.fish   # edit the source, not the live file
chezmoi cd            # drop into this repo
```

Apps that rewrite their own config (Zed, Cursor, Karabiner) won't tell you they changed something. `chezmoi status` is how you find out — run it before committing.

## Machine-local overrides

Keep machine-specific settings out of this repo instead of merging them:

- **fish** — anything in `~/.config/fish/conf.d/local.fish` is auto-sourced and untracked. Secrets go here, never in `config.fish`.
- **ghostty** — `config.local` next to the tracked config, pulled in by `config-file = ?local`. Later files win, so it overrides anything above it.

## New machine

```sh
brew install chezmoi
chezmoi init git@github.com:i11v/dotfiles.git --source ~/Developer/dotfiles
chezmoi diff     # ALWAYS review before applying on a machine with existing configs
chezmoi apply
```

`--source` keeps the checkout here rather than chezmoi's default `~/.local/share/chezmoi`; it's recorded in `~/.config/chezmoi/chezmoi.toml`, which is machine-local and deliberately not tracked.
