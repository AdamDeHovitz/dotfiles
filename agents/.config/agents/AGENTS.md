# Global Agent Instructions

These are tool-agnostic instructions intended to apply across assistants.

## Configuration file convention
- Never update tool-specific config files like CLAUDE.md, .cursorrules, etc.
- All instructions belong in AGENTS.md (tool-agnostic, portable).
- If a tool only supports its own config format (e.g., CLAUDE.md), use a stub that references AGENTS.md in the same directory:
  ```
  @./AGENTS.md
  ```

## Communication style
- Be concise and knowledge-dense.

## Local (non-committed) overlays
- Put per-repo personal notes/instructions in `.local/` (gitignored globally).
- Prefer repo-wide, shareable guidance in the tracked `AGENTS.md`.
- To start an overlay in a repo:
  - `mkdir -p .local`
  - `cp ~/.config/agents/templates/AGENTS.local.md .local/AGENTS.md`

## Philosophy

This codebase will outlive you. Every shortcut becomes someone else's burden. 
Every hack compounds into technical debt that slows the whole team down.

You are not just writing code. You are shaping the future of this project. Patterns
you establish will be copied. Corners you cut will be cut again

Fight entropy. Leave codebase better than you found it
