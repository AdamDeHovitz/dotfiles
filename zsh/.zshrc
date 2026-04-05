# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"


# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git z docker kubectl history-substring-search zbell)

# zbell: bell when long commands finish (triggers Ghostty tab 🔔)
zbell_duration=15
zbell_ignore=($EDITOR $PAGER less more man ssh top htop btop watch)

source $ZSH/oh-my-zsh.sh

# User configuration

# Set vim as the default editor
export EDITOR='nvim'
export VISUAL='nvim'

# Enable vim mode for command line
bindkey -v

# Better history settings
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS          # Don't record duplicate entries
setopt HIST_IGNORE_SPACE         # Don't record entries starting with space
setopt HIST_REDUCE_BLANKS        # Remove unnecessary blanks
setopt EXTENDED_HISTORY          # Record timestamp of command

# Useful developer aliases
alias v="nvim"
alias vi="nvim"
if command -v bat >/dev/null 2>&1; then
  alias cat="bat"
fi
if command -v eza >/dev/null 2>&1; then
  alias ll="eza -lah --icons --git"
  alias la="eza -a --icons"
  alias ls="eza --icons"
  alias tree="eza --tree --icons"
else
  alias ll="ls -lah"
  alias la="ls -A"
fi
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline -20"
alias gp="git pull"
alias gc="git commit"
alias ga="git add"
alias gco="git checkout"
alias gb="git branch"
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"

# Quick edit configs
alias zshrc="nvim ~/.zshrc"
alias vimrc="nvim ~/.vimrc"

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/Cellar/bash/5.3.9/bin:$PATH"


# PostgreSQL@17
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/postgresql@17/lib"
export CPPFLAGS="-I/opt/homebrew/opt/postgresql@17/include"

alias k=kubectl

# Claude Code aliases
# cl = CLaude, clh/s/o = model (Haiku/Sonnet/Opus)
: "${CLAUDE_FLAGS:=}"
cl() { claude ${=CLAUDE_FLAGS} "$@"; }
clh() { claude --model haiku ${=CLAUDE_FLAGS} "$@"; }
cls() { claude --model sonnet ${=CLAUDE_FLAGS} "$@"; }
clo() { claude --model opus ${=CLAUDE_FLAGS} "$@"; }
clc() { claude --continue ${=CLAUDE_FLAGS} "$@"; }
clr() { claude --resume ${=CLAUDE_FLAGS} "$@"; }
clp() { claude --print ${=CLAUDE_FLAGS} "$@"; }
cly() { claude --dangerously-skip-permissions "$@"; }  # Yes to all (use cautiously)

# Source local secrets (API keys, tokens, etc.)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
alias python3=python3.12

# Git branch select with fzf
alias gbs='git branch --sort=-committerdate | fzf --height 40% | xargs git checkout'

# cd to a project, ensure clean, update main
cdp() {
  local project="$1"
  [[ -z "$project" ]] && { echo "Usage: cdp <project>"; return 1; }

  local repo="$HOME/Projects/$project"
  [[ ! -d "$repo/.git" ]] && { echo "Error: $repo is not a git repo"; return 1; }

  cd "$repo" || return 1
  if [[ -n "$(git status --porcelain)" ]]; then
    echo "Aborting: unstaged changes present in $repo"
    return 1
  fi

  git checkout main || return 1
  git pull --ff-only || return 1
}

# Shared assistant worktree launcher
# Usage: _agent_wt <launcher_fn> <command_name> <repo> <feature> [parent]
_agent_wt() {
  local launcher_fn="$1" command_name="$2"
  shift 2

  local repo="$1" feature="$2" parent="${3:-Projects}"
  [[ -z "$repo" || -z "$feature" ]] && { echo "Usage: ${command_name} <repo> <feature> [parent]"; return 1; }

  local parent_dir="$HOME/$parent"
  local main_repo="$parent_dir/$repo"
  local wt_dir="$parent_dir/${repo}-worktrees"
  local wt_path="$wt_dir/$feature"

  [[ ! -d "$main_repo/.git" ]] && { echo "Error: $main_repo is not a git repo"; return 1; }

  # Set tab title to uppercase feature name (hyphens -> spaces)
  local tab_title="${feature//-/ }"
  tab_title="${tab_title:u}"
  printf '\033]0;%s\007' "$tab_title"

  mkdir -p "$wt_dir" || return 1
  git -C "$main_repo" fetch origin main || return 1
  git -C "$main_repo" worktree add -b "ad/$feature" "$wt_path" origin/main || return 1

  git -C "$main_repo" ls-files --others --directory -z | while IFS= read -r -d '' _entry; do
    local _clean="${_entry%/}" _base="${_entry%%/*}"
    _base="${_base%/}"
    case "$_base" in
      .git|.DS_Store|.direnv|.nproject|.nworkspace|.codex|.cursor|.continue) continue ;;
      .aider*|*.egg-info) continue ;;
      node_modules|__pycache__|.venv|.pytest_cache|.ruff_cache|.mypy_cache|.terraform|.tox|.cache|dist|.coverage) continue ;;
    esac
    [[ -e "$wt_path/$_clean" || -L "$wt_path/$_clean" ]] && continue
    local _dir="${_clean%/*}"
    [[ "$_dir" != "$_clean" ]] && mkdir -p "$wt_path/$_dir"
    ln -s "$main_repo/$_clean" "$wt_path/$_clean"
  done

  cd "$wt_path" || return 1
  "$launcher_fn"
}

_clwt_launch() {
  cl
}

_cowt_launch() {
  codex
}

# Claude Worktree - quickly spin up a worktree and start Claude
# Usage: clwt <repo> <feature> [parent]
# Mnemonic: CLaude WorkTree
# parent: optional folder under $HOME (default: Projects)
clwt() {
  _agent_wt _clwt_launch clwt "$@"
}

# Codex Worktree - quickly spin up a worktree and start Codex
# Usage: cowt <repo> <feature> [parent]
# Mnemonic: COdex WorkTree
# parent: optional folder under $HOME (default: Projects)
cowt() {
  _agent_wt _cowt_launch cowt "$@"
}

# Remove synced worktrees - inverse of clwt
# Usage: rmwt [--dry-run] [--force] [repo]
#   --dry-run: Show what would be removed without removing (default behavior)
#   --force:   Actually remove the worktrees
#   repo:      Optional - limit to specific repo's worktrees
rmwt() {
  local dry_run=true
  local target_repo=""

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --force) dry_run=false; shift ;;
      --dry-run) dry_run=true; shift ;;
      *) target_repo="$1"; shift ;;
    esac
  done

  local wt_base="$HOME/Projects"
  local removed=0
  local skipped=0

  # Find all worktree directories
  for wt_dir in "$wt_base"/*-worktrees; do
    [[ ! -d "$wt_dir" ]] && continue

    local repo_name="${wt_dir##*/}"
    repo_name="${repo_name%-worktrees}"

    # Filter by repo if specified
    [[ -n "$target_repo" && "$repo_name" != "$target_repo" ]] && continue

    local main_repo="$wt_base/$repo_name"
    [[ ! -d "$main_repo/.git" ]] && continue

    # Iterate through worktrees in this directory
    for wt_path in "$wt_dir"/*(/N); do
      [[ -z "$wt_path" ]] && continue
      wt_path="${wt_path%/}"
      local feature="${wt_path##*/}"

      # Safety check 1: uncommitted changes
      if [[ -n "$(git -C "$wt_path" status --porcelain 2>/dev/null)" ]]; then
        echo "SKIP: $repo_name/$feature - has uncommitted changes"
        ((skipped++))
        continue
      fi

      # Safety check 2: upstream exists
      local upstream=""
      upstream=$(git -C "$wt_path" rev-parse --abbrev-ref '@{u}' 2>/dev/null)
      if [[ -z "$upstream" ]]; then
        echo "SKIP: $repo_name/$feature - no upstream branch (not pushed)"
        ((skipped++))
        continue
      fi

      # Safety check 3: no unpushed commits
      local ahead=""
      ahead=$(git -C "$wt_path" rev-list --count '@{u}..HEAD' 2>/dev/null)
      if [[ "$ahead" -gt 0 ]]; then
        echo "SKIP: $repo_name/$feature - $ahead unpushed commit(s)"
        ((skipped++))
        continue
      fi

      # Safe to remove
      if $dry_run; then
        echo "WOULD REMOVE: $repo_name/$feature"
        ((removed++))
      else
        echo "REMOVING: $repo_name/$feature"
        git -C "$main_repo" worktree remove "$wt_path" && ((removed++))
      fi
    done
  done

  echo ""
  if $dry_run; then
    echo "Dry run complete. $removed removable, $skipped skipped. Use --force to actually remove."
  else
    echo "Removed $removed worktree(s), skipped $skipped."
  fi
}
