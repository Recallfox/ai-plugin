# recallfox for Hermes Agent

This adapter registers the shared recallfox skill with Hermes as
`recallfox:recallfox`. The MCP connection is configured separately because
Hermes manages remote MCP servers in its own config.

## Install or update

```sh
curl -fsSL https://raw.githubusercontent.com/Recallfox/ai-plugin/main/.hermes-plugin/install.sh | bash
hermes plugins enable recallfox
```

Re-running the installer pulls the latest plugin version. Start a new Hermes
session after installing or updating, then verify with `/plugins`.

## Connect recallfox

```sh
hermes mcp add recallfox --url https://app.recallfox.com/api/v1/mcp --auth oauth
hermes mcp login recallfox
```

The browser authorization is a one-time connection to the user's recallfox
account. Once connected, ask Hermes to load `recallfox:recallfox` with
`skill_view` before capturing or organizing cards.

## Layout

```text
.hermes-plugin/
├── plugin.yaml       Hermes manifest
├── __init__.py       registers ../skills/recallfox/SKILL.md
├── install.sh        clone/update and symlink installer
└── README.md         Hermes-specific setup
```

