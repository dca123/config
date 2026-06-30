#!/bin/sh
set -eu

pi_version="0.79.8"
pi_package="@earendil-works/pi-coding-agent@$pi_version"

if ! command -v npm >/dev/null 2>&1; then
  echo "npm not found; install Node.js before applying the Pi setup" >&2
  exit 0
fi

if ! command -v pi >/dev/null 2>&1 || ! pi --version 2>/dev/null | grep -qx "$pi_version"; then
  npm install -g "$pi_package"
fi

agent="$HOME/.pi/agent"
mkdir -p "$agent"

if [ ! -f "$agent/settings.json" ]; then
  cat > "$agent/settings.json" <<EOF
{
  "lastChangelogVersion": "0.79.8",
  "defaultProvider": "openai-codex",
  "defaultModel": "gpt-5.5",
  "theme": "tokyo-night",
  "hideThinkingBlock": true,
  "defaultThinkingLevel": "high",
  "steeringMode": "one-at-a-time",
  "transport": "websocket-cached",
  "websocketConnectTimeoutMs": 60000,
  "packages": [
    "$HOME/Projects/pi-context",
    "$HOME/Projects/pi-context-prune",
    "https://github.com/pasky/pi-omplike-advisor"
  ],
  "terminal": {
    "showImages": true
  },
  "doubleEscapeAction": "tree",
  "compaction": {
    "enabled": true,
    "reserveTokens": 32768,
    "keepRecentTokens": 160000
  },
  "_packages_deferred": [
    "npm:@ogulcancelik/pi-session-recall",
    "git:git@github.com:davebcn87/pi-autoresearch@main",
    "npm:pi-rewind",
    "npm:pi-mono-multi-edit",
    "$HOME/Projects/plannotator/apps/pi-extension",
    "npm:pi-nvim"
  ]
}
EOF
fi

for dir in \
  "$agent/npm" \
  "$agent/extensions-deferred/sweep" \
  "$agent/extensions-deferred/web-fetch"
do
  if [ -f "$dir/package.json" ]; then
    (cd "$dir" && npm install)
  fi
done

skills_target="$HOME/Projects/plannotator/apps/pi-extension/skills"
skills_link="$agent/skills/plannotator"
if [ -d "$skills_target" ]; then
  mkdir -p "$agent/skills"
  if [ ! -e "$skills_link" ]; then
    ln -s "$skills_target" "$skills_link"
  elif [ -L "$skills_link" ] && [ "$(readlink "$skills_link")" != "$skills_target" ]; then
    echo "Pi plannotator skill link points somewhere else: $skills_link" >&2
  fi
fi
