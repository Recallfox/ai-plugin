<div align="center">

<img src="assets/mascot.svg" alt="recallfox" width="160" />

# recallfox plugin

**Turn anything you learn with your AI into durable memory.**

The official [recallfox](https://recallfox.com) plugin for Claude Code, Codex, Cursor, and Gemini CLI.

<sub>recallfox is the retention layer you push into. This plugin is the push.</sub>

</div>

Create decks and cards in recallfox without leaving your terminal, and let the
spaced-repetition scheduler resurface them over time so the knowledge actually sticks.

## What's inside

- **MCP connector** (`recallfox`) connects to the remote recallfox MCP server and exposes
  deck, topic, Learning Path, and card operations, scoped to your account over OAuth:
  - inspect decks, retention, topics, progress/access, and existing cards;
  - create/update/delete/reorder topics and configure or study ahead in a Learning Path;
  - create/update/delete cards, assign them to topics, and move them across decks.
- **Skill** (`recallfox`) teaches the agent when and how to capture what you learn as
  well-formed Basic, Cloze, or Options cards; choose the retrieval-appropriate type; reuse existing
  structure; reason about locked topics and retention; and ask before making structural changes.
- **Commands**
  - `/recallfox:recall-this [topic]` capture the conversation (or a topic) into cards.

## Install

### Claude Code

Install the full plugin (MCP connector + skill + commands) from this repo:

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
card-writing guidance:

```
gemini extensions install https://github.com/Recallfox/ai-plugin
```

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
  gemini-extension.json Gemini CLI extension (mcp-remote bridge)
  GEMINI.md             Gemini context file (card-writing guidance)
  .mcp.json             recallfox MCP connector (dotted, shared)
  mcp.json              recallfox MCP connector (non-dotted duplicate, some clients)
  skills/recallfox/     when + how to capture cards (Claude Code, Codex)
  commands/             slash commands (.md for Claude Code, .toml for Gemini)
```

## Updating the plugin

There is no release process. The repo is the distribution, so shipping an update is
just commit and push to `main`. Optionally bump `version` in the manifests (semver) when
the change is worth signalling.

Anyone who has it installed picks up the change with `/plugin marketplace update recallfox`.
