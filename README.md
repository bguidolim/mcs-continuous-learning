# Bruno's Personal Setup

A [tech pack](https://github.com/bguidolim/MyClaudeSetup) that turns Claude Code into a **self-improving iOS development environment** — with persistent memory, semantic code navigation, Xcode integration, and opinionated git workflows.

Built for the [`mcs`](https://github.com/bguidolim/MyClaudeSetup) configuration engine.

```
identifier: bruno-setup
version:    1.0.0
requires:   mcs >= 2026.2.24
```

---

## What Is This?

[`mcs`](https://github.com/bguidolim/MyClaudeSetup) is a configuration engine for Claude Code — think Terraform for your AI coding environment. Instead of manually registering MCP servers, copying hook scripts, and editing settings for every project, you define everything in a **tech pack** and let the engine handle installation.

This tech pack packages a complete Claude Code setup: 4 MCP servers, 5 plugins, 4 session hooks, 2 slash commands, custom skills, per-project templates, and a **continuous learning system** that gives Claude long-term memory across sessions.

Tech packs are **composable** — `mcs` can apply multiple packs to the same project, and packs can declare peer dependencies on each other. This setup could easily be split into a general-purpose Core pack and a separate iOS pack. Since it's a personal setup, I chose to keep everything in one place for simplicity.

---

## Continuous Learning — The Core Feature

### The Problem

Claude Code has no memory between sessions. Every conversation starts from zero — solutions discovered yesterday, architecture decisions made last week, debugging breakthroughs from last month — all gone. You end up re-explaining the same context, re-discovering the same workarounds, and re-making the same decisions.

### The Solution

This pack implements a **closed-loop knowledge system** that captures valuable insights during work and resurfaces them automatically when they're relevant again.

```
                              CONTINUOUS LEARNING LOOP

 ┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
 │   SESSION    │     │  KNOWLEDGE   │     │     WORK     │     │   CAPTURE    │
 │    START     │────>│  RETRIEVAL   │────>│   SESSION    │────>│   (save)     │
 └──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
        |                    ^                                          |
        |                    |            .claude/memories/             |
        |                    |     ┌──────────────────────────────┐     |
        |                    |     │  learning_swiftui_...        │     |
        |                    |     │  decision_arch_...           │     |
        |                    +-----│  learning_coredata_...       │<----+
        |                          │  decision_testing_...        │
        |                          └──────────────────────────────┘
        |                                        ^
        |                                        |
        |               ┌──────────────────────────────────┐
        |               │       Ollama Embeddings          │
        +──────────────>│       (nomic-embed-text)         │
         background     │       + Semantic Index           │
         re-index on    └──────────────────────────────────┘
         session start
```

### The Four Pieces

| Piece | What | How |
|-------|------|-----|
| **Activator Hook** | Triggers evaluation after every prompt | A `PreToolUse` hook reminds Claude to check if the current task produced extractable knowledge |
| **Continuous Learning Skill** | Structures and saves knowledge | A Claude Code skill with extraction rules, quality gates, naming conventions, and ADR-inspired templates |
| **Memory Files** | Persistent storage | Structured markdown files in `.claude/memories/` — version-controlled, human-readable, editable |
| **Semantic Search** | Retrieval at session start | `docs-mcp-server` + Ollama embeddings index memory files and serve them via natural-language search |

### Memory Types

The system captures two categories of knowledge:

**Learnings** — non-obvious discoveries from debugging and investigation:
```
.claude/memories/learning_swiftui_task_cancellation_on_view_dismiss.md
.claude/memories/learning_core_data_batch_insert_memory_spike.md
.claude/memories/learning_xcode_preview_crash_missing_environment.md
```

Each learning follows a structured template: **Problem → Trigger Conditions → Solution → Verification → Example → Notes → References**.

**Decisions** — deliberate architectural and convention choices:
```
.claude/memories/decision_architecture_mvvm_coordinators.md
.claude/memories/decision_testing_snapshot_strategy.md
.claude/memories/decision_codestyle_naming_conventions.md
```

Decisions use an ADR-inspired template: **Decision → Context → Options Considered → Choice → Consequences → Scope → Examples**.

### The Feedback Loop in Practice

1. **Session starts** → the Ollama status hook detects `.claude/memories/` and re-indexes all memory files into a vector store using `nomic-embed-text` embeddings (runs in the background, doesn't block the session)

2. **Before any task** → a `CLAUDE.local.md` instruction tells Claude to search the knowledge base first (`search_docs` with the project name), surfacing relevant past learnings and decisions

3. **During work** → the activator hook fires on every prompt, reminding Claude to evaluate whether the current interaction produced knowledge worth saving

4. **After valuable work** → the continuous learning skill extracts structured memories, checks for duplicates against the existing KB, and writes them to `.claude/memories/`

5. **Next session** → the new memories are indexed, and the loop continues

Over time, the project accumulates a searchable knowledge base that makes Claude increasingly effective — debugging patterns don't need to be rediscovered, architectural decisions don't need to be re-justified, and conventions don't need to be re-explained.

---

## What's Included

### MCP Servers

| Server | Description |
|--------|-------------|
| **docs-mcp-server** | Semantic search over project memories using local Ollama embeddings |
| **Serena** | LSP-powered code navigation and symbol-level editing via language server |
| **XcodeBuildMCP** | Build, test, run, and manage iOS simulators through Xcode — no raw `xcodebuild` |
| **Sosumi** | Apple developer documentation search |

### Plugins

| Plugin | Description |
|--------|-------------|
| **explanatory-output-style** | Structured, educational response formatting with insight callouts |
| **pr-review-toolkit** | Specialized agents for code review, silent failure hunting, type design analysis |
| **ralph-loop** | Iterative refinement loop for complex multi-step tasks |
| **claude-md-management** | Audit and improve `CLAUDE.md` files across repositories |
| **claude-hud** | On-screen display showing context usage, active tools, and agent status |

### Session Hooks

| Hook | Event | What It Does |
|------|-------|-------------|
| **session_start.sh** | `SessionStart` | Injects git status, branch protection warnings, ahead/behind tracking, open PRs |
| **ollama-status.sh** | `SessionStart` | Checks Ollama health, background-indexes memory files for semantic search |
| **ios-simulator-status.sh** | `SessionStart` | Detects booted iOS simulator and reports its UUID |
| **continuous-learning-activator.sh** | `PreToolUse` | Reminds Claude to evaluate knowledge extraction after each prompt |

### Slash Commands

| Command | Description |
|---------|-------------|
| `/commit` | Stage, commit, push — analyzes the actual diff, writes structured commit messages |
| `/pr` | Full pipeline: commit → push → create PR via `gh` → trigger knowledge capture |

### Skills

| Skill | Description |
|-------|-------------|
| **continuous-learning** | Extracts learnings and decisions from sessions into structured memory files |
| **xcodebuildmcp** | Loads XcodeBuildMCP tool catalog and workflow guidance |

### Templates (CLAUDE.local.md)

| Section | Instructions |
|---------|-------------|
| **continuous-learning** | Always search the KB before starting any task |
| **serena** | Prefer Serena's symbolic tools over Read/Edit for Swift files |
| **ios** | Use XcodeBuildMCP for all build/test, target simulator by UUID, never suppress warnings |
| **git** | Branch naming conventions, read-only PR reviews, commit message format |

### Settings

| Setting | Value | Purpose |
|---------|-------|---------|
| `defaultMode` | `plan` | Claude asks for approval before making changes |
| `alwaysThinkingEnabled` | `true` | Extended thinking on every response |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | `claude-sonnet-4-6` | Upgrades lightweight model tasks to Sonnet |
| `CLAUDE_CODE_DISABLE_AUTO_MEMORY` | `1` | Disables built-in memory in favor of the continuous learning system |

---

## Session Lifecycle

When you start a Claude Code session in a project configured with this pack, here's what happens before you type a single prompt:

```
claude                           ← you start a session
  │
  ├─ SessionStart hooks fire:
  │   ├─ session_start.sh        → "Branch: feature/login, ⬆️ 2 commits ahead, 🔀 Open PR #42"
  │   ├─ ollama-status.sh        → "🦙 Ollama: running" + background re-index of memories
  │   └─ ios-simulator-status.sh → "Booted Simulator: iPhone 16 Pro [UUID]"
  │
  ├─ CLAUDE.local.md loads:
  │   ├─ "Search the KB before any task"
  │   ├─ "Use Serena for Swift files"
  │   ├─ "Use XcodeBuildMCP for builds"
  │   └─ "Branch naming: feature/{ticket}-description"
  │
  └─ Claude is now context-aware, memory-equipped, and ready to work
```

---

## Installation

### Prerequisites

- macOS (Apple Silicon or Intel)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- Xcode Command Line Tools (`xcode-select --install`)

### Setup

```bash
# 1. Install mcs
brew install bguidolim/tap/my-claude-setup

# 2. Register this tech pack
mcs pack add https://github.com/bguidolim/mcs-personal-setup

# 3. Sync your project
cd ~/Developer/my-ios-project
mcs sync

# 4. Verify everything is healthy
mcs doctor
```

During `mcs sync`, you'll be prompted for:

| Prompt | What It Does | Default |
|--------|-------------|---------|
| **Xcode project** | Auto-detects `*.xcodeproj` / `*.xcworkspace` files for XcodeBuildMCP | *(detected)* |
| **Branch prefix** | Sets git branch naming convention (e.g. `feature/ABC-123-login`) | `feature` |

---

## Directory Structure

```
mcs-personal-setup/
├── techpack.yaml                       # Manifest — defines all components
├── config/
│   └── settings.json                   # Claude Code settings (plan mode, env vars)
├── hooks/
│   ├── session_start.sh                # Git status + branch protection
│   ├── ollama-status.sh                # Ollama health + memory re-indexing
│   ├── ios-simulator-status.sh         # Booted simulator detection
│   └── continuous-learning-activator.sh # Knowledge extraction reminder
├── commands/
│   ├── commit.md                       # /commit slash command
│   └── pr.md                           # /pr slash command
├── skills/
│   └── continuous-learning/
│       ├── SKILL.md                    # Extraction rules and workflow
│       └── references/
│           └── templates.md            # Learning + Decision memory templates
├── templates/
│   ├── continuous-learning.md          # "Search KB before any task"
│   ├── serena.md                       # "Use Serena for Swift"
│   ├── ios.md                          # iOS simulator + XcodeBuildMCP rules
│   └── git.md                          # Branch naming + commit conventions
└── scripts/
    └── configure-xcode.sh              # Creates .xcodebuildmcp/config.yaml
```

---

## Customization

You don't need to install everything. Run `mcs sync --customize` and select only the components you want — skip the iOS tooling, pick just the continuous learning system, or mix and match.

For deeper changes, fork the pack and make it yours:

1. **Fork** this repository
2. **Edit** `techpack.yaml` — add or remove components, change identifiers
3. **Modify** templates, hooks, or skills to match your workflow
4. **Register** your fork: `mcs pack add https://github.com/you/your-fork`

The `techpack.yaml` schema is documented in the [MCS tech pack schema reference](https://github.com/bguidolim/MyClaudeSetup/blob/main/docs/techpack-schema.md).

---

## Links

- [MCS (My Claude Setup)](https://github.com/bguidolim/MyClaudeSetup) — the configuration engine
- [Creating Tech Packs](https://github.com/bguidolim/MyClaudeSetup/blob/main/docs/creating-tech-packs.md) — guide for building your own
- [Tech Pack Schema](https://github.com/bguidolim/MyClaudeSetup/blob/main/docs/techpack-schema.md) — full YAML reference

---

## License

MIT
