# SpeakPen Skill

[English](README.md) | [简体中文](README.zh-CN.md)

An agent skill (`SKILL.md`) that teaches an AI agent when and how to use the user's
**SpeakPen** voice notes — the ideas they talked out on their phone or in a browser,
transcribed and summarized by SpeakPen.

Ask your agent things like:

- "What did I say about the launch plan this week?"
- "Find my notes on pricing and tell me where I landed"
- "Turn everything I recorded yesterday into a to-do list"

## Do I need a SpeakPen account?

You can read, copy and install the skill files without an account. **Using its SpeakPen
note tools requires a SpeakPen account and authorization** — OAuth through MCP, or a
personal API token. An API token is another way to authorize the same account, not an
account-free mode.

| What you want to do | Current requirement |
|---|---|
| Read, adapt or install the MIT-licensed skill | No SpeakPen account |
| Search and read your SpeakPen notes | Account + OAuth or API token |
| Get useful results from your own notes | At least one completed SpeakPen note |
| Transcribe local audio or read arbitrary local Markdown with this skill | Not implemented here |

A paid SpeakPen subscription is not required just to connect this read-only integration.
Recording and other service features remain subject to your plan's limits. Your AI
client may have separate access requirements and costs.

This repository currently has **no guest mode, runnable sample-data mode or local
transcription engine**. The skill teaches your agent a workflow; it does not replace the
SpeakPen app or hosted service.

[Start with a free SpeakPen account](https://speakpen.app/?utm_source=github-speakpen-skill&utm_medium=readme)
→ record a short idea → wait for it to finish processing → connect your agent → ask a
question below.

## How it reaches your notes

1. **MCP (preferred)** — connect `https://speakpen.app/mcp` once (see
   [speakpen-mcp](https://github.com/Qumge/speakpen-mcp)). The skill uses its `search`,
   `fetch` and `list_recent_notes` tools.
2. **HTTP fallback** — set `SPEAKPEN_TOKEN` to an API token from
   https://speakpen.app/app → Settings → Connections → Developers. The skill uses the read-only API
   ([API reference](skills/speakpen/references/api-reference.md)).

Access is read-only: the agent can't create, change or delete notes and never receives audio.

## Install

**Claude Code** (installs the skill and the `speakpen` MCP server; you sign in to SpeakPen
via OAuth the first time the tools are used):

```
/plugin marketplace add Qumge/speakpen-skill
/plugin install speakpen@speakpen
```

The same from a shell: `claude plugin marketplace add Qumge/speakpen-skill` then
`claude plugin install speakpen@speakpen`.

**Other agents / manual** — copy `skills/speakpen` into your agent's skills directory
(Claude Code: `~/.claude/skills/`), then connect `https://speakpen.app/mcp` in your agent
or use the HTTP fallback above:

```bash
git clone https://github.com/Qumge/speakpen-skill
mkdir -p ~/.claude/skills
cp -R speakpen-skill/skills/speakpen ~/.claude/skills/speakpen
```

## Where to start

- [Connection guide](https://speakpen.app/connect?utm_source=github-speakpen-skill&utm_medium=readme) — client setup and authorization.
- This repository is the agent workflow; [speakpen-mcp](https://github.com/Qumge/speakpen-mcp) documents the hosted transport. You do not need both repositories checked out.

## Also

- [speakpen-mcp](https://github.com/Qumge/speakpen-mcp) — the hosted MCP server's docs
- [SpeakPen Sync for Obsidian](https://github.com/xnjiang/speakpen-obsidian) — your notes as Markdown in your vault

## License

MIT covers the files in this repository, including the skill and documentation. It does
not grant a license to SpeakPen's hosted backend or access to anyone's notes. The hosted
service is governed by [SpeakPen's terms](https://speakpen.app/terms).
