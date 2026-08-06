<div align="center">

<img src="assets/mascot.svg" alt="recallfox" width="160" />

# recallfox plugin

**Turn anything you learn with your AI into durable memory.**

The official [recallfox](https://recallfox.com) plugin for Claude Code, Codex, Cursor, Gemini CLI,
and Hermes Agent.

<sub>recallfox is the retention layer you push into. This plugin is the push.</sub>

</div>

Create interactive Lessons, decks, and cards in recallfox without leaving your terminal. Teach a
new idea through examples, then let spaced repetition resurface it so the knowledge actually sticks.

## What's inside

- **MCP connector** (`recallfox`) connects to the remote recallfox MCP server and exposes
  deck, topic, Learning Path, Lesson, and card operations, scoped to your account over OAuth:
  - inspect decks, retention, topics, progress/access, existing Lessons, and cards;
  - create/update/delete/reorder topics and configure or study ahead in a Learning Path;
  - create/update/delete/reorder interactive Lessons and their HTML steps;
  - create/update/delete cards, assign them to topics, and move them across decks.
- **Skills** teach the agent how to retain and teach what you learn:
  - `recallfox` captures durable ideas as well-formed Basic, Cloze, or Options cards, chooses the
    retrieval-appropriate type, reuses existing structure, reasons about locked topics and
    retention, and asks before making changes;
  - `author-lessons` creates focused, phone-friendly teaching experiences using sandboxed HTML,
    optional self-hosted libraries, examples, visual flows, and meaningful interaction.
- **Commands**
  - `/recallfox:recall-this [topic]` capture the conversation (or a topic) into cards.

## Install

### Claude Code

Install the full plugin (MCP connector + skills + commands) from this repo:

```
/plugin marketplace add Recallfox/ai-plugin
/plugin install recallfox
```

On first use, Claude Code walks you through a one-time OAuth authorization in the browser to
connect the recallfox MCP server to your account. Nothing else to configure.

### Codex

Same repo, same plugin. Codex reads `.codex-plugin/plugin.json` (which points at the shared
`skills/` and `.mcp.json`), so install it from the marketplace:

```
codex plugin marketplace add Recallfox/ai-plugin
codex plugin add recallfox@recallfox
```

Auth is the same one-click browser OAuth as Claude Code. There is no API key to paste.

### Cursor

Cursor reads `.cursor-plugin/plugin.json` and wires the recallfox MCP connector (Cursor has
no skill or command system, so those do not apply). Install it, then complete the one-time
browser OAuth on first use. No API key needed.

### Gemini CLI

Gemini installs the connector through the `mcp-remote` bridge and reads `GEMINI.md` for the
Lesson and card-authoring guidance:

```
gemini extensions install https://github.com/Recallfox/ai-plugin
```

### Hermes Agent

Install the Hermes adapter, which registers the shared RecallFox skills, then enable it:

```
curl -fsSL https://raw.githubusercontent.com/Recallfox/ai-plugin/main/.hermes-plugin/install.sh | bash
hermes plugins enable recallfox
```

Then add the recallfox MCP server with OAuth and sign in:

```
hermes mcp add recallfox --url https://app.recallfox.com/api/v1/mcp --auth oauth
hermes mcp login recallfox
```

Start a new Hermes session and ask it to load `recallfox:recallfox` with `skill_view` before
capturing cards. Load `recallfox:author-lessons` before authoring interactive Lessons. Hermes keeps
plugin skills namespaced and opt-in, while the MCP connection exposes the recallfox deck, topic,
Learning Path, Lesson, and card tools.

### Other MCP clients (fallback)

Any MCP client can point directly at `https://app.recallfox.com/api/v1/mcp`. Clients that
support OAuth complete a one-time browser authorization (the server does dynamic client
registration). Clients that do not can authenticate with a recallfox **API key**
(`rf_live_...`, created in the app under Connect) sent as a bearer token.

## Layout

```
ai-plugin/
  .agents/plugins/
    marketplace.json    cross-agent marketplace listing (Codex, Grok, modern Claude)
  .claude-plugin/
    plugin.json         Claude Code manifest
    marketplace.json    Claude Code marketplace listing
  .codex-plugin/
    plugin.json         Codex manifest (full interface block; shares skills/ + .mcp.json)
  .cursor-plugin/
    plugin.json         Cursor manifest (registers the MCP connector)
  .hermes-plugin/
    plugin.yaml         Hermes Agent manifest
    __init__.py         registers the shared skills
    install.sh          clone/update and symlink installer
  gemini-extension.json Gemini CLI extension (mcp-remote bridge)
  GEMINI.md             Gemini context file (Lesson + card guidance)
  .mcp.json             recallfox MCP connector (dotted, shared)
  mcp.json              recallfox MCP connector (non-dotted duplicate, some clients)
  skills/recallfox/     when + how to capture durable knowledge
  skills/author-lessons/ lesson pedagogy, sandbox runtime, libraries, and examples
  commands/             slash commands (.md for Claude Code, .toml for Gemini)
```

## Updating the plugin

There is no release process. The repo is the distribution, so shipping an update is
just commit and push to `main`. Optionally bump `version` in the manifests (semver) when
the change is worth signalling.

Claude Code users pick up the change with `/plugin marketplace update recallfox`. Hermes users
re-run the `.hermes-plugin/install.sh` command above, then start a new session.
