# dotfiles

Personal macOS configs, kept in one place so a new machine ends up like the last one:

- fish
- Ghostty
- Neovim
- Zed
- Cursor
- Karabiner
- Finicky
- herdr
- Codex

Managed with [chezmoi](https://chezmoi.io), which owns the files in `$HOME` directly rather than symlinking them.

## Gotchas

- Machine-local fish settings and secrets go in `~/.config/fish/conf.d/local.fish` — auto-sourced, untracked, and referenced nowhere in `config.fish`.
- Zed, Cursor, and Karabiner rewrite their own configs without saying so. `chezmoi status` is the only thing that surfaces the drift.
- Codex rewrites `~/.codex/config.toml` with machine-local state and may store credentials in it. The chezmoi modifier manages selected durable settings without copying the complete file into Git.
