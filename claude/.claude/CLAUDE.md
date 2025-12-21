## Git Branch Naming

- All branches should be prefixed with `ad/`

## Git Commit Style

- Rebase on main, never merge other branches
- Each commit = one clear logical change; squash intermediate commits (too small, later overwritten, or superseded)
- Commit title: ≤72 chars, imperative mood, no prefixes
  - Good: "fix configuration file loading", "add user deletion support"
  - Bad: "fix bug", "bugfix: fix thing", "add new features"
- Use commit body for non-trivial bugs: explain WHY it happened, not just the fix
- Before PR: interactive rebase to squash/split into clean patches
- Never include Claude Code signature or Co-Authored-By lines in commits or PRs

## YAML Style

- Always quote string values

## Communication Style

- Be concise and knowledge-dense