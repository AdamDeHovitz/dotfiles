# Dotfiles

Personal configuration files managed with GNU Stow.

## Structure

```
dotfiles/
├── claude/     # Claude Code settings
├── gh/         # GitHub CLI config
├── nvim/       # Neovim configuration
├── vim/        # Vim configuration
└── zsh/        # Zsh shell configuration
```

## Installation

### Prerequisites

Install GNU Stow:

```bash
# macOS
brew install stow

# Linux (Debian/Ubuntu)
apt-get install stow
```

### Apply configurations

From this directory, use stow to symlink configurations to your home directory:

```bash
# Install all configurations
stow */

# Install specific configurations
stow nvim
stow zsh
stow claude

# Remove configurations
stow -D nvim
```

### What gets installed

- `claude/` → `~/.claude/`
- `gh/` → `~/.config/gh/`
- `nvim/` → `~/.config/nvim/`
- `vim/` → `~/.vimrc`
- `zsh/` → `~/.zshrc`

## Notes

- Work-specific configuration should go in `~/Projects/.claude.md`
- This repo contains personal/shared configuration only
- Backup existing configs before stowing to avoid conflicts
