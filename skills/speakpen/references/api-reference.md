# SpeakPen HTTP API (read-only subset for agents)

Base URL: `https://speakpen.app`. Every request: `Authorization: Bearer <API token>`
(created at https://speakpen.app/app → Settings → Connections → Developers). API tokens are **read-only**:
any write returns 403.

Prefer the MCP server (`https://speakpen.app/mcp`, tools `search` / `fetch` /
`list_recent_notes`) when your client supports MCP — it has keyword search; this API doesn't.

## GET /api/v1/ideas

List the user's notes, newest first.

| Param | Meaning |
|---|---|
| `page` | 1-based page (default 1) |
| `per_page` | 1–50 (default 20) |
| `since` | ISO 8601 time; only notes **created** at or after it |
| `updated_since` | ISO 8601 time; notes **changed** at or after it, oldest change first (for incremental sync) |
| `category` | `meeting`, `lecture`, `interview`, `notes` or `other` |

Response (JSON:API):

```json
{
  "data": [
    { "id": "412", "type": "idea",
      "attributes": {
        "title": "Slogan: fresh bread before 7am",
        "message": "Slogan idea for the restaurant: fresh bread before seven.",
        "transcript_text": "Okay quick idea for the restaurant…",
        "category": "notes",
        "status": "completed",
        "created_at": "2026-10-02T01:51:36.509Z",
        "updated_at": "2026-10-02T01:52:01.112Z",
        "last_transcription_error": null,
        "audio_url": "…" } } ],
  "meta": { "current_page": 1, "total_pages": 3, "total_count": 52, "per_page": 20 }
}
```

- `message` is the AI summary; `transcript_text` is the full transcript.
- `status` other than `completed` means it's still being processed (or failed) — skip it.
- `audio_url` is a short-lived signed link to the recording. Agents should ignore it.

## GET /api/v1/ideas/:id

One note, same attributes as above, under `data`.

## GET /api/v1/ideas/:id/markdown

The note as a Markdown file (YAML frontmatter + summary + transcript), `text/markdown`.

## GET /api/v1/ideas/export

A ZIP of up to 1000 notes as Markdown files. Optional `since` (ISO 8601 date). Large — only
use it when the user asks to export everything.

## Errors

| Status | Meaning |
|---|---|
| 401 | Missing / invalid / revoked token |
| 403 | The token tried to write (read-only) |
| 404 | No such note for this user |
| 429 | Rate limited — back off |
