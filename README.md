# SpeakPen Skill

An agent skill (`SKILL.md`) that teaches an AI agent when and how to use the user's
**SpeakPen** voice notes — the ideas they talked out on their phone or in a browser,
transcribed and summarized by SpeakPen.

Ask your agent things like:

- "What did I say about the launch plan this week?"
- "Find my notes on pricing and tell me where I landed"
- "Turn everything I recorded yesterday into a to-do list"

## How it reaches your notes

1. **MCP (preferred)** — connect `https://speakpen.app/mcp` once (see
   [speakpen-mcp](https://github.com/xnjiang/speakpen-mcp)). The skill uses its `search`,
   `fetch` and `list_recent_notes` tools.
2. **HTTP fallback** — set `SPEAKPEN_TOKEN` to an API token from
   https://speakpen.app/app → Settings → API Tokens. The skill uses the read-only API
   (`references/api-reference.md`).

Access is read-only: the agent can't create, change or delete notes and never receives audio.

## Install

Copy this folder into your agent's skills directory, e.g. for Claude Code:

```bash
git clone https://github.com/xnjiang/speakpen-skill ~/.claude/skills/speakpen
```

## Also

- [speakpen-mcp](https://github.com/xnjiang/speakpen-mcp) — the hosted MCP server's docs
- [SpeakPen Sync for Obsidian](https://github.com/xnjiang/speakpen-obsidian) — your notes as Markdown in your vault

## License

MIT (this skill). The SpeakPen service is governed by speakpen.app's terms.
