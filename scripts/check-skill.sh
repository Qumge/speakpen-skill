#!/usr/bin/env bash
# Also validates the plugin/marketplace manifests.
# SKILL.md is what an agent acts on. If the MCP tool list or the read-only API changes, the
# skill goes stale silently. This checks both against the live service.
#   SPEAKPEN_TOKEN=<API token> scripts/check-skill.sh
set -euo pipefail
base="${SPEAKPEN_URL:-https://speakpen.app}"
token="${SPEAKPEN_TOKEN:?set SPEAKPEN_TOKEN to an API token}"
root="$(cd "$(dirname "$0")/.." && pwd)"
skill="$root/skills/speakpen/SKILL.md"

# Manifests: both JSON files parse and the marketplace source path exists.
for f in .claude-plugin/marketplace.json .claude-plugin/plugin.json .mcp.json; do
  jq -e . "$root/$f" >/dev/null || { echo "$f is not valid JSON" >&2; exit 1; }
done
src="$(jq -r '.plugins[0].source' "$root/.claude-plugin/marketplace.json")"
[ -d "$root/$src" ] || { echo "marketplace plugin source $src does not exist" >&2; exit 1; }
[ -f "$skill" ] || { echo "missing $skill" >&2; exit 1; }

live="$(curl -sf -X POST "$base/mcp" -H 'Content-Type: application/json' \
  -H 'Accept: application/json, text/event-stream' -H "Authorization: Bearer $token" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}' | jq -r '.result.tools[].name' | sort)"
documented="$(grep -oE '^\| `[a-z_]+` \|' "$skill" | tr -d '|` ' | sort)"
if [ "$live" != "$documented" ]; then
  echo "MCP tools drifted from SKILL.md" >&2
  diff <(echo "$documented") <(echo "$live") --label documented --label live >&2 || true
  exit 1
fi

status="$(curl -s -o /dev/null -w '%{http_code}' "$base/api/v1/ideas?per_page=1" -H "Authorization: Bearer $token")"
[ "$status" = "200" ] || { echo "GET /api/v1/ideas returned $status" >&2; exit 1; }

echo "OK: $(echo "$live" | wc -l | tr -d ' ') MCP tools match SKILL.md; HTTP API reachable"
