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

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# User configuration

# Pick the best available editor on this host.
if command -v nvim >/dev/null 2>&1; then
  export EDITOR='nvim'
elif command -v vim >/dev/null 2>&1; then
  export EDITOR='vim'
else
  export EDITOR='vi'
fi
export VISUAL="$EDITOR"

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
alias v="$EDITOR"
alias vi="$EDITOR"
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
zshrc() { "$EDITOR" ~/.zshrc; }
vimrc() { "$EDITOR" ~/.vimrc; }

# PATH
export PATH="$HOME/.local/bin:$PATH"
[[ -d /opt/homebrew/Cellar/bash/5.3.9/bin ]] && export PATH="/opt/homebrew/Cellar/bash/5.3.9/bin:$PATH"


# PostgreSQL@17
if [[ -d /opt/homebrew/opt/postgresql@17/bin ]]; then
  export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
  export LDFLAGS="-L/opt/homebrew/opt/postgresql@17/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/postgresql@17/include"
fi

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
if command -v python3.12 >/dev/null 2>&1; then
  alias python3=python3.12
fi

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

  git -C "$main_repo" ls-files --others --exclude-standard -z | while IFS= read -r -d '' _entry; do
    local _clean="${_entry%/}" _skip=false
    local _segments=("${(@s:/:)_clean}")
    local _segment
    for _segment in "${_segments[@]}"; do
      case "$_segment" in
        .git|.DS_Store|.direnv|.agents|.idea|.nproject|.nworkspace|.codex|.cursor|.continue) _skip=true ;;
        .aider*|*.egg-info) _skip=true ;;
        node_modules|__pycache__|.venv|.pytest_cache|.ruff_cache|.mypy_cache|.terraform|.tox|.cache|dist|.coverage) _skip=true ;;
      esac
      [[ "$_skip" == true ]] && break
    done
    [[ "$_skip" == true ]] && continue
    case "$_clean" in
      */agents/agents) continue ;;
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
  codex -c 'tui.terminal_title=[]'
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
# Usage: rmwt [--dry-run] [--force] [--mode conservative|moderate] [--older-than DAYS] [repo]
#   --dry-run: Show what would be removed without removing (default behavior)
#   --force:   Actually remove the worktrees
#   --mode:    conservative removes clean synced worktrees; moderate also prunes stale merged/gone branches
#   repo:      Optional - limit to specific repo's worktrees
rmwt() {
  local dry_run=true
  local target_repo=""
  local mode="moderate"
  local older_than_days=14

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --force) dry_run=false; shift ;;
      --dry-run) dry_run=true; shift ;;
      --mode)
        [[ -n "$2" ]] || { echo "Error: --mode requires a value"; return 1; }
        mode="$2"
        shift 2
        ;;
      --older-than)
        [[ -n "$2" ]] || { echo "Error: --older-than requires a value"; return 1; }
        older_than_days="$2"
        shift 2
        ;;
      --help|-h)
        echo "Usage: rmwt [--dry-run] [--force] [--mode conservative|moderate] [--older-than DAYS] [repo]"
        return 0
        ;;
      *) target_repo="$1"; shift ;;
    esac
  done

  if [[ "$mode" != "conservative" && "$mode" != "moderate" ]]; then
    echo "Error: --mode must be conservative or moderate"
    return 1
  fi
  if ! [[ "$older_than_days" =~ '^[0-9]+$' ]]; then
    echo "Error: --older-than must be a non-negative integer"
    return 1
  fi

  local wt_base="$HOME/Projects"
  local removed=0
  local skipped=0
  local reviewed=0
  local now_epoch="$(date +%s)"
  local cutoff_epoch=$(( now_epoch - older_than_days * 86400 ))
  local -a repos

  if [[ -n "$target_repo" ]]; then
    repos=("$wt_base/$target_repo")
  else
    local wt_dir
    for wt_dir in "$wt_base"/*-worktrees(N/); do
      local repo_name="${wt_dir:t}"
      repo_name="${repo_name%-worktrees}"
      repos+=("$wt_base/$repo_name")
    done
  fi

  local main_repo
  for main_repo in "${repos[@]}"; do
    [[ ! -d "$main_repo/.git" ]] && continue

    local repo_name="${main_repo:t}"
    local main_repo_real="${main_repo:A}"
    git -C "$main_repo" fetch --prune origin >/dev/null 2>&1 || echo "WARN: $repo_name - could not refresh origin refs"

    local origin_url repo_slug=""
    origin_url=$(git -C "$main_repo" remote get-url origin 2>/dev/null)
    case "$origin_url" in
      git@github.com:*) repo_slug="${origin_url#git@github.com:}"; repo_slug="${repo_slug%.git}" ;;
      https://github.com/*) repo_slug="${origin_url#https://github.com/}"; repo_slug="${repo_slug%.git}" ;;
    esac

    local -A pr_state pr_number
    if [[ "$mode" == "moderate" && -n "$repo_slug" ]] && command -v gh >/dev/null 2>&1; then
      local pr_head pr_status pr_num pr_updated
      while IFS=$'\t' read -r pr_head pr_status pr_num pr_updated; do
        [[ -z "$pr_head" ]] && continue
        pr_state[$pr_head]="$pr_status"
        pr_number[$pr_head]="$pr_num"
      done < <(gh -R "$repo_slug" pr list --state all --limit 500 --json headRefName,state,number,updatedAt --jq '.[] | [.headRefName, .state, (.number | tostring), .updatedAt] | @tsv' 2>/dev/null)
    fi

    echo "== $repo_name =="

    local wt_path="" wt_head="" wt_branch="" wt_detached=false wt_prunable=false
    local line
    while IFS= read -r line || [[ -n "$line" ]]; do
      if [[ -z "$line" ]]; then
        [[ -n "$wt_path" ]] || continue

        if [[ "${wt_path:A}" == "$main_repo_real" ]]; then
          wt_path="" wt_head="" wt_branch="" wt_detached=false wt_prunable=false
          continue
        fi

        ((reviewed++))

        if [[ "$wt_prunable" == true ]]; then
          echo "PRUNE METADATA: $wt_path"
          if $dry_run; then
            ((removed++))
          else
            git -C "$main_repo" worktree prune --verbose >/dev/null && ((removed++))
          fi
          wt_path="" wt_head="" wt_branch="" wt_detached=false wt_prunable=false
          continue
        fi

        if [[ ! -d "$wt_path" ]]; then
          echo "SKIP: $wt_path - path missing but not marked prunable"
          ((skipped++))
          wt_path="" wt_head="" wt_branch="" wt_detached=false wt_prunable=false
          continue
        fi

        local label="${wt_path#$wt_base/}" branch="${wt_branch#refs/heads/}" reason=""

        if [[ "$wt_detached" == true || -z "$branch" ]]; then
          echo "SKIP: $label - detached HEAD"
          ((skipped++))
          wt_path="" wt_head="" wt_branch="" wt_detached=false wt_prunable=false
          continue
        fi

        if [[ -n "$(git -C "$wt_path" status --porcelain 2>/dev/null)" ]]; then
          echo "SKIP: $label - has uncommitted changes"
          ((skipped++))
          wt_path="" wt_head="" wt_branch="" wt_detached=false wt_prunable=false
          continue
        fi

        local commit_epoch="$(git -C "$main_repo" log -1 --format=%ct "$branch" 2>/dev/null)"
        if [[ -n "$commit_epoch" && "$commit_epoch" -gt "$cutoff_epoch" ]]; then
          echo "SKIP: $label - last commit is newer than ${older_than_days}d"
          ((skipped++))
          wt_path="" wt_head="" wt_branch="" wt_detached=false wt_prunable=false
          continue
        fi

        local upstream="" upstream_gone=false ahead=0 merged=false
        upstream=$(git -C "$main_repo" rev-parse --abbrev-ref "$branch@{u}" 2>/dev/null)
        if [[ -n "$upstream" ]]; then
          if ! git -C "$main_repo" rev-parse --verify --quiet "$upstream" >/dev/null; then
            upstream_gone=true
          else
            ahead=$(git -C "$main_repo" rev-list --count "$upstream..$branch" 2>/dev/null)
          fi
        fi
        if git -C "$main_repo" merge-base --is-ancestor "$branch" origin/main 2>/dev/null; then
          merged=true
        fi

        local state="${pr_state[$branch]}" num="${pr_number[$branch]}"
        if [[ "$state" == "OPEN" ]]; then
          echo "SKIP: $label - open PR #$num"
          ((skipped++))
          wt_path="" wt_head="" wt_branch="" wt_detached=false wt_prunable=false
          continue
        fi

        if [[ -n "$upstream" && "$upstream_gone" == false && "$ahead" -gt 0 ]]; then
          echo "SKIP: $label - $ahead unpushed commit(s)"
          ((skipped++))
          wt_path="" wt_head="" wt_branch="" wt_detached=false wt_prunable=false
          continue
        fi

        if [[ "$mode" == "conservative" ]]; then
          if [[ -z "$upstream" ]]; then
            echo "SKIP: $label - no upstream branch"
            ((skipped++))
            wt_path="" wt_head="" wt_branch="" wt_detached=false wt_prunable=false
            continue
          fi
          reason="clean and synced"
        elif [[ "$merged" == true ]]; then
          reason="merged into origin/main"
        elif [[ "$upstream_gone" == true ]]; then
          reason="upstream gone"
        elif [[ "$state" == "MERGED" || "$state" == "CLOSED" ]]; then
          reason="PR #$num is ${state:l}"
        else
          echo "SKIP: $label - not merged, gone, or closed"
          ((skipped++))
          wt_path="" wt_head="" wt_branch="" wt_detached=false wt_prunable=false
          continue
        fi

        if $dry_run; then
          echo "WOULD REMOVE: $label - $reason"
          ((removed++))
        else
          echo "REMOVING: $label - $reason"
          git -C "$main_repo" worktree remove "$wt_path" && ((removed++))
        fi

        wt_path="" wt_head="" wt_branch="" wt_detached=false wt_prunable=false
        continue
      fi

      case "$line" in
        worktree\ *) wt_path="${line#worktree }" ;;
        HEAD\ *) wt_head="${line#HEAD }" ;;
        branch\ *) wt_branch="${line#branch }" ;;
        detached) wt_detached=true ;;
        prunable*) wt_prunable=true ;;
      esac
    done < <(git -C "$main_repo" worktree list --porcelain)

    if $dry_run; then
      echo "Prunable metadata:"
      git -C "$main_repo" worktree prune --dry-run --verbose
    fi
    echo ""
  done

  if $dry_run; then
    echo "Dry run complete. $removed removable/prunable, $skipped skipped, $reviewed reviewed. Use --force to actually remove."
  else
    echo "Removed/pruned $removed item(s), skipped $skipped, reviewed $reviewed."
  fi
}
