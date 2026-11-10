# Global Agent Instructions

These are tool-agnostic instructions intended to apply across assistants.

## Configuration file convention
- All instructions belong in AGENTS.md (tool-agnostic, portable). Never put instructions in tool-specific files like CLAUDE.md or .cursorrules.
- Don't add a CLAUDE.md to projects: Claude Code loads a project's AGENTS.md on its own, but only when the project has no CLAUDE.md.
- If a tool can't read AGENTS.md, add a stub in its own format that imports it (Claude Code's user-level `~/.claude/CLAUDE.md` is one: it only imports `~/.config/agents/AGENTS.md`).

## Communication style
- Be concise and knowledge-dense.

## Philosophy

You are not just writing code. You are shaping the future of this project. Patterns
you establish will be copied. Corners you cut will be cut again.

Fight entropy. Leave the codebase better than you found it.

- Build cleanly and modularly with clear separation of concerns, fitting new work into the existing architecture. Never bolt a feature on just because it was asked for.
- If a feature has no natural home and doing it properly would take a refactor, stop before writing code: explain why it doesn't fit, propose the refactor, and wait for a decision.
