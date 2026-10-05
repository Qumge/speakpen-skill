---
name: speakpen
description: Read the user's SpeakPen voice notes — ideas they spoke into their phone or browser, transcribed and summarized — and use them as the user's own thinking. Use when the user asks what they said, recorded, noted or were thinking about something ("what did I say about pricing?", "my notes from this week", "the idea I recorded while walking"), wants their spoken ideas summarized, compared, turned into a plan, tasks or a draft, or mentions SpeakPen. Read-only.
homepage: https://speakpen.app
license: MIT
metadata:
  author: SpeakPen
  version: 0.2.0
  category: productivity
  clawdbot:
    requires:
      bins:
        - curl
        - jq
---

# SpeakPen Skill

**Audience: AI Agent**

SpeakPen is where the user talks their ideas out — walking, driving, between meetings —
instead of typing them. Each recording becomes a **note**: a title, a short summary and the
full transcript, in whatever language they spoke. Those notes are the user's raw thinking.
Your job is to find the right ones and build on them; the user should never have to replay
audio or remember which day they said something.

**Access is read-only.** You can search, list and read notes. You cannot create, edit or
delete them, and you never get audio. Only finished notes are visible; one that is still
transcribing doesn't exist yet as far as you can see.

## Two ways in — prefer MCP

### 1. MCP (preferred)

If a `speakpen` MCP server is connected you will see these tools. Use them; nothing else in
this file is needed.

| Tool | Use it for |
|---|---|
| `search` | Topic questions: "what did I say about X". Keywords in, up to 10 notes out (id, title, url, date, snippet). |
| `fetch` | Read one note in full (transcript + summary) before quoting or relying on it. |
| `list_recent_notes` | Time questions: "this week", "yesterday", "since the 1st". `since` / `until` are ISO 8601; a bare date is that day in UTC. Newest first, up to 50. |

Not connected and the user wants it? Tell them to add the server once:
- ChatGPT / Claude.ai / Claude Desktop: add a custom connector with the URL `https://speakpen.app/mcp`, then approve read-only access on the SpeakPen page that opens.
- Claude Code: `claude mcp add --transport http speakpen https://speakpen.app/mcp`
- Others (Cursor, VS Code, Codex): see https://github.com/xnjiang/speakpen-mcp

### 2. HTTP API (fallback, when MCP isn't available)

Needs an API token the user creates at https://speakpen.app/app → Settings → API Tokens.
Read it from the environment (`SPEAKPEN_TOKEN`); never ask the user to paste it into chat
history if their client can set environment variables, and never echo it back.

```bash
# Recent notes (newest first). Optional: since=2026-10-01T00:00:00Z, category=notes|meeting|lecture|interview|other
curl -s "https://speakpen.app/api/v1/ideas?per_page=20" \
  -H "Authorization: Bearer $SPEAKPEN_TOKEN" | jq '.data[] | {id, title: .attributes.title, created_at: .attributes.created_at, status: .attributes.status}'

# One note in full
curl -s "https://speakpen.app/api/v1/ideas/<id>" \
  -H "Authorization: Bearer $SPEAKPEN_TOKEN" | jq '.data.attributes | {title, message, transcript_text, category, created_at}'
```

The HTTP API has **no keyword search**. For a topic question, list recent notes (page through
with `page=2…`, `per_page` up to 50) and match titles and summaries yourself, then read the
candidates in full. Skip notes whose `status` isn't `completed`. Ignore `audio_url` — never
download, play or show it.

Full endpoint list and response shapes: `references/api-reference.md`.

## How to answer well

- **Search, then read.** Titles and snippets are for finding notes, not for quoting. Read the
  note (`fetch`) before you state what the user said.
- **Search in the user's words and language.** Notes are transcribed in the language spoken
  — a Chinese note won't match an English keyword. If the first search is empty, try
  synonyms, the other language the user writes in, or switch to `list_recent_notes` for the
  likely time range.
- **Cite.** When you rely on a note, give its title and date, and its `url` if you have one
  (it opens the note in SpeakPen). The user should be able to check you.
- **Their words are rough.** Transcripts are spoken thinking: repetitions, half-sentences,
  changes of mind mid-note. The *latest* note on a topic usually wins; point out when notes
  contradict each other instead of silently picking one.
- **Don't invent notes.** If nothing matches, say so and say what you searched.

## Errors

| You see | Meaning | Do |
|---|---|---|
| HTTP 401 | Token missing, wrong, revoked or expired | Ask the user to reconnect SpeakPen (MCP) or create a new API token. Don't retry in a loop. |
| Tool error "Note not found" | Wrong id, still transcribing, or not theirs | Search again; don't guess ids. |
| Tool error "Too many requests" | Over 60 tool calls a minute | Wait a minute; batch your reads. |
| HTTP 429 | Too many HTTP requests | Back off, then retry once. |

Never show raw API errors or JSON to the user — explain in one sentence what to do.
