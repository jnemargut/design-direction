# design-direction

A [Claude Code](https://claude.ai/code) skill that helps you explore design microdecisions on your existing codebase, without leaving your editor.

Whenever you have a design instinct you can't quite articulate, or a vague feeling that something isn't working: ask it. This skill opens a browser preview showing your current design alongside 4 live, functional alternatives. You pick a direction, and Claude applies the change surgically to your source files.

---

## What it does

Design decisions are hard to evaluate in the abstract. You want to *see* the options, not imagine them. `design-direction` generates a real HTML preview (real fonts, actual CSS, functional components) so you can compare at a glance and make a confident call.

**Ask about anything visual:**
- Colors, palettes, and theming
- Typography and font pairings
- Spacing, density, and whitespace
- Component and page layouts
- Button and form styles
- Navigation and sidebar design
- Card and list treatments
- Dark mode and contrast
- Data visualization
- Mood, tone, and overall aesthetic
- ...or just say "something feels off" and let it explore

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
/design-direction "this page feels really heavy, help me lighten it up"
```

```
/design-direction "I'm not loving the typography on the landing page"
```

```
/design-direction "explore color options for the sidebar"
```

```
/design-direction "the spacing on these cards feels off"
```

```
/design-direction "I want a moodier feel for the hero section"
```

```
/design-direction "these buttons don't feel right, show me alternatives"
```

```
/design-direction "the color palette feels dated"
```

A browser window will open showing your **current design** plus **Options A, B, C, and D**, each with a functional visual preview, a short rationale, and pros/cons. Pick one (or ask for a variation), and Claude edits your source files.

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

Changes are precise: only the specific design values are touched, not surrounding logic or structure.

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
│  [live preview]      │  │  [live preview]      │
│  + Calm, professional│  │  + Energetic, warm   │
│  - Can feel cold     │  │  - Assertive         │
└──────────────────────┘  └──────────────────────┘
```

Fonts load from Google Fonts, layouts use real CSS, and components render functionally, so what you see is close to what you'll get.

---

## License

MIT
