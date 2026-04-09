## MANDATORY — Before Starting Any Task

Before writing code, planning, or exploring — **always search the knowledge base first**:

1. **Search the KB** — use the `docs-mcp-server` tools (`search_docs`) and set the `library` parameter to the name of the current project folder. The library name always matches the root directory name of this project. This server indexes `.claude/memories/` — it contains past learnings, debugging discoveries, and architectural decisions from previous sessions, not external documentation. Try multiple keyword variations if needed.
2. **Read matching memories** — review any relevant results for full context (architecture decisions, gotchas, patterns from past sessions).

Only after completing these steps should you proceed with discovery and implementation.

### When to re-check mid-session

Search the KB again **before starting** whenever the work shifts to a new phase, including but not limited to:
- **Writing or updating tests** — check for testing conventions, patterns, preferred frameworks
- **Refactoring** — check for architectural decisions and code style preferences
- **Error handling / validation** — check for established patterns
- **CI/CD or deployment** — check for workflow decisions
- **New integration** — check for conventions on networking, data layer, etc.

Past sessions often contain decisions and patterns that prevent unnecessary iterations and PR comments.