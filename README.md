# Dotfiles

Personal configuration files managed with GNU Stow.

## Structure

```
dotfiles/
├── agents/     # Tool-agnostic agent instructions
├── claude/     # Claude Code settings (backcompat)
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
stow -t ~ */

# Install specific configurations
stow -t ~ nvim
stow -t ~ zsh
stow -t ~ agents
stow -t ~ claude

# Remove configurations
stow -D -t ~ nvim
```

### What gets installed

- `agents/` → `~/.config/agents/`
- `claude/` → `~/.claude/`
- `gh/` → `~/.config/gh/`
- `nvim/` → `~/.config/nvim/`
- `vim/` → `~/.vimrc`
- `zsh/` → `~/.zshrc`

## Notes

- Work-specific configuration should go in `~/Projects` (repo-tracked `AGENTS.md` is fine; personal overlays should go in `.agents.local/`)
- This repo contains personal/shared configuration only
- Backup existing configs before stowing to avoid conflicts
