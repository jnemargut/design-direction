# design-direction

A [Claude Code](https://claude.ai/code) skill that helps you explore design microdecisions on your existing codebase — without leaving your editor.

When you're not sure whether your chart should use teal or amber, whether your dashboard needs more whitespace, or whether that font is really working — this skill opens a browser preview showing your current design alongside 4 live, functional alternatives. You pick a direction, and Claude applies the change surgically to your source files.

---

## What it does

Design decisions are hard to evaluate in the abstract. You want to *see* the options, not imagine them. `design-direction` generates a real HTML preview — functional charts, real fonts, actual CSS — so you can compare at a glance and make a confident call.

**Supports:**
- Colors and color palettes
- Typography and font pairings
- Data visualization (bar charts, line charts, etc.)
- Component and page layouts

**Works with:** React, Next.js, Vue, Svelte, vanilla HTML

---

## Installation

Requires [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview) to be installed.

```bash
mkdir -p ~/.claude/skills/design-direction

curl -o ~/.claude/skills/design-direction/SKILL.md \
  https://raw.githubusercontent.com/jnemargut/design-direction/main/SKILL.md

curl -o ~/.claude/skills/design-direction/detect-stack.sh \
  https://raw.githubusercontent.com/jnemargut/design-direction/main/detect-stack.sh

chmod +x ~/.claude/skills/design-direction/detect-stack.sh
```

That's it. No npm install, no config files.

---

## Usage

Open Claude Code in your project directory and run:

```
/design-direction "I don't love the bar chart colors — show me options"
```

```
/design-direction "explore font options for the dashboard"
```

```
/design-direction "this layout feels cluttered, what are my options?"
```

```
/design-direction "the primary button color feels off"
```

A browser window will open showing your **current design** plus **Options A, B, C, and D** — each with a functional visual preview, a short rationale, and pros/cons. Pick one (or ask for a variation), and Claude edits your source files.

---

## How it works

The skill runs a 7-phase workflow:

| Phase | What happens |
|-------|-------------|
| **1. Clarify** | Parses your question; asks one follow-up if needed |
| **2. Detect stack** | Identifies React, Vue, Svelte, Next.js, or vanilla HTML |
| **3. Find the code** | Searches your codebase for the relevant component or styles |
| **4. Generate options** | Creates 4 distinct design directions (e.g. warm, cool, neutral, bold) |
| **5. Preview** | Writes `.design-direction-preview.html` with functional renders |
| **6. Open** | Opens the preview in your browser |
| **7. Apply** | Edits your source files surgically for the option you choose |

Changes are precise — only the specific design values are touched, not surrounding logic or structure.

---

## Example output

The preview shows cards like this:

```
┌─────────────────────────────────────────────────┐
│  CURRENT                                        │
│  Your existing design, rendered live            │
└─────────────────────────────────────────────────┘

┌──────────────────────┐  ┌──────────────────────┐
│  Option A            │  │  Option B            │
│  Ocean Blue          │  │  Warm Coral          │
│  [live chart/font]   │  │  [live chart/font]   │
│  + Calm, professional│  │  + Energetic, warm   │
│  - Can feel cold     │  │  - Assertive         │
└──────────────────────┘  └──────────────────────┘
```

Charts use Chart.js, fonts load from Google Fonts, and layouts use real CSS — so what you see is close to what you'll get.

---

## License

MIT
