#!/usr/bin/env bash
# detect-stack.sh
# Identifies the web tech stack of the current project.
# Outputs a single word: react | vue | svelte | next | vanilla-html | unknown
# Usage: bash ~/.claude/skills/design-direction/detect-stack.sh

set -euo pipefail

if [ -f package.json ]; then
  if grep -q '"next"' package.json 2>/dev/null; then
    echo "next"; exit 0
  fi
  if grep -q '"react"' package.json 2>/dev/null; then
    echo "react"; exit 0
  fi
  if grep -q '"vue"' package.json 2>/dev/null; then
    echo "vue"; exit 0
  fi
  if grep -q '"svelte"' package.json 2>/dev/null; then
    echo "svelte"; exit 0
  fi
fi

# Fall back to file extension detection
if find . -maxdepth 4 \( -name "*.tsx" -o -name "*.jsx" \) 2>/dev/null | head -1 | grep -q .; then
  echo "react"; exit 0
fi

if find . -maxdepth 4 -name "*.vue" 2>/dev/null | head -1 | grep -q .; then
  echo "vue"; exit 0
fi

if find . -maxdepth 4 -name "*.svelte" 2>/dev/null | head -1 | grep -q .; then
  echo "svelte"; exit 0
fi

if find . -maxdepth 4 -name "*.html" 2>/dev/null | head -1 | grep -q .; then
  echo "vanilla-html"; exit 0
fi

echo "unknown"
