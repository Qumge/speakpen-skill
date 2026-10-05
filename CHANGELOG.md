# Changelog

## 0.2.1

- Moved to the Qumge organization: `/plugin marketplace add Qumge/speakpen-skill`. The old `xnjiang/speakpen-skill` address redirects.

## 0.2.0 — 2026-10-05

- Now a Claude Code plugin marketplace: `/plugin marketplace add Qumge/speakpen-skill`,
  `/plugin install speakpen@speakpen`. Bundles the hosted MCP server (`.mcp.json`).
- Skill moved to `skills/speakpen/`; the root `marketplace.json` (not a format Claude Code
  reads) is replaced by `.claude-plugin/marketplace.json`. The old
  `git clone ... ~/.claude/skills/speakpen` no longer works; see README.

## 0.1.0 — 2026-10-02

- First version. Teaches an agent to read SpeakPen voice notes: MCP tools `search`, `fetch`,
  `list_recent_notes` first; read-only HTTP API with an API token as the fallback.
