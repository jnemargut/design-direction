---
name: design-direction
description: Use when the user wants to explore design alternatives for a UI microdecision in an existing codebase. Shows a local visual preview of the current design plus up to 4 alternatives with pros/cons. Trigger phrases: "show me options", "I don't love this design", "can we try a different look", "explore alternatives", "design crit", "what would this look like with X", "show me some color options", "explore font options". NOT for use before a codebase exists — requires existing code to analyze.
argument-hint: "[design question or what you want to explore]"
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Write, Bash(open *), Bash(bash *), Bash(find *), Bash(python3 *)
---

# Design Direction Skill

You are helping the user explore design alternatives for a specific UI decision in their **existing** codebase. You will:

1. Understand what they want to explore
2. Find the relevant code
3. Generate a self-contained HTML preview showing CURRENT + up to 4 alternatives
4. Open it in their browser
5. Apply the chosen direction surgically to the real source files

The user's design question is: **$ARGUMENTS**

---

## PHASE 1 — Clarify the Design Question

Read `$ARGUMENTS` carefully.

If the question is clear and specific (e.g. "show me color options for the bar chart"), proceed to Phase 2 immediately. Do NOT ask for clarification on clearly stated questions.

If `$ARGUMENTS` is empty, fewer than 5 characters, or only says something like "design" or "help", ask ONE focused question:

> "Which specific element would you like to explore options for? For example: the color scheme, a button style, the chart type, typography, card layout, or navigation style?"

Wait for their answer, treat it as the new `$ARGUMENTS`, then proceed.

---

## PHASE 2 — Identify the Tech Stack

Run the stack detection script:

```bash
bash ~/.claude/skills/design-direction/detect-stack.sh
```

If the script is not found or fails, detect manually:
- Check for `package.json` — read it for "react", "next", "vue", "svelte", "vite"
- Check file extensions: `.tsx`, `.jsx` → react; `.vue` → vue; `.svelte` → svelte
- Check for `.html` files at root → vanilla-html

Set STACK to one of: `react` | `vue` | `svelte` | `next` | `vanilla-html` | `unknown`

**If NO web files exist at all** (no `.html`, `.css`, `.tsx`, `.jsx`, `.vue`, `.svelte`), stop and tell the user:

> "This skill works with web codebases (HTML, CSS, React, Vue, Svelte, Next.js). I don't see any web files in the current directory. Are you in the right project folder?"

Do not proceed further if no web files are found.

---

## PHASE 3 — Find the Relevant Code

Your goal: locate the specific file(s) and line(s) where the design element is implemented.

### Step 3a — Keyword Search

Parse `$ARGUMENTS` for key nouns and search with Grep + Glob. Examples:

- "bar chart" → search for `BarChart`, `bar-chart`, `recharts`, `chart`, `<Bar`, `Chart.js`
- "button color" → search for `button`, `btn`, `backgroundColor`, `bg-`
- "typography" / "fonts" → search for `font-family`, `fontFamily`, `@import`, `--font`
- "card layout" → search for `card`, `Card`, `.card`, `grid-template`
- "nav" / "navigation" → search for `nav`, `Nav`, `sidebar`, `Sidebar`

Search in: `src/`, `components/`, `pages/`, `app/`, `styles/`, `css/`, `*.css`, `*.scss`, `*.module.css`, `*.tsx`, `*.jsx`, `*.vue`, `*.html`

### Step 3b — Read Candidates

Read the top 3–5 most relevant files. Focus on:
- The component or element the user is asking about
- CSS custom properties / tokens in `:root { --color-... }`
- Inline styles, style objects, className values
- Charting library configuration (recharts, chart.js, d3, victory, apexcharts)

### Step 3c — Extract Current Design Values

For the element in question, extract and note:
- Primary color(s) — hex, rgb, hsl, or CSS token name
- Secondary/accent colors
- Typography (font-family, font-size, font-weight)
- Component type (e.g. "currently a bar chart", "currently a checkbox")
- Any other relevant properties (border-radius, spacing, shadows)

If code spans more than 5 files, focus on the **primary rendering file** — the one closest to the actual rendered output. Note in the preview that other files also contribute.

---

## PHASE 4 — Generate 4 Alternative Directions

Create exactly 4 alternatives. Each must:
1. Be a **meaningful visual change** — not a subtle tweak
2. Have a **clear rationale** — why would a designer choose this?
3. Use realistic, specific values (real hex codes, real font names, real CSS properties)
4. Have a **2–4 word evocative name**: "Ocean Blue", "Warm Coral", "Slate Minimal", "Bold Contrast"

### Generation Rules by Decision Type

**COLOR decisions:**
- Option A — Warm shift: rotate hue +35–45° toward orange/red
- Option B — Cool shift: rotate hue −35–45° toward blue/violet
- Option C — Neutral/Minimal: desaturate to ~15%, use near-grays
- Option D — Bold/High-contrast: increase saturation +25%, decrease lightness −15%

**CHART/DATA VIZ decisions:**
- Option A — Different chart type that shows same data differently (bar → line, pie → bar)
- Option B — Minimal/stripped (remove decoration, only essential data ink)
- Option C — Rich/detailed (labels, tooltips visible, legend, gradient fills)
- Option D — Style-shifted (rounded bars, soft colors, card-contained)

**TYPOGRAPHY decisions:**
- Option A — Geometric sans-serif: Inter, DM Sans, or Plus Jakarta Sans
- Option B — Humanist/warm sans: Nunito, Lato, or Source Sans 3
- Option C — Serif/editorial: Playfair Display, Lora, or Merriweather
- Option D — Monospace/technical: JetBrains Mono, Fira Code, or IBM Plex Mono

**LAYOUT decisions:**
- Option A — More whitespace: generous padding, breathing room
- Option B — Compact/dense: tighter spacing, more information density
- Option C — Structural rearrangement: e.g. horizontal → vertical, sidebar → top nav
- Option D — Card-based containment: group elements in bordered panels

**COMPONENT TYPE decisions (e.g. switch vs checkbox):**
- Option A — The alternative component type they mentioned
- Option B — A third component type that also fits
- Option C — Custom-styled version of current component
- Option D — Hybrid/combination approach

---

## PHASE 5 — Generate the HTML Preview File

Write a single self-contained HTML file to:
```
.design-direction-preview.html
```
(in the current working directory / project root)

### Required HTML Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Design Direction Preview</title>
  <!-- Load Chart.js ONLY if exploring data visualization -->
  <!-- <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script> -->
  <!-- Load Google Fonts ONLY if exploring typography — load all variants in one @import -->
  <style>
    /* Page styles, card styles, pros/cons styles — see CSS below */
  </style>
</head>
<body>
  <header>
    <h1>Design Direction</h1>
    <p class="question">"[INSERT USER'S EXACT QUESTION HERE]"</p>
    <p class="instruction">Browse the options below. When you've decided, tell Claude: <strong>"I'll go with Option A"</strong> (or B, C, D, or "keep current")</p>
  </header>

  <main class="options-grid">
    <!-- CURRENT card: spans full width -->
    <!-- Option A card -->
    <!-- Option B card -->
    <!-- Option C card -->
    <!-- Option D card -->
  </main>
</body>
</html>
```

### Option Card HTML Structure

Each of the 5 cards must follow this structure:

```html
<article class="option-card [current|option-a|option-b|option-c|option-d]">
  <div class="card-header">
    <span class="option-label">[CURRENT | OPTION A | OPTION B | OPTION C | OPTION D]</span>
    <h2 class="option-title">[2-4 word evocative name, e.g. "Ocean Blue" or "Warm Coral"]</h2>
  </div>

  <div class="visual-preview">
    <!-- FUNCTIONAL RENDERED VISUAL — see rules below -->
  </div>

  <div class="verdict">
    <div class="pros">
      <h3>Works well when</h3>
      <ul>
        <li>[specific context where this excels]</li>
        <li>[another context]</li>
      </ul>
    </div>
    <div class="cons">
      <h3>Watch out for</h3>
      <ul>
        <li>[specific trade-off or risk]</li>
        <li>[another trade-off]</li>
      </ul>
    </div>
  </div>

  <div class="card-footer">
    <code class="tell-claude">Tell Claude: "I'll go with [Option A / Option B / etc.]"</code>
  </div>
</article>
```

### Visual Preview Rules — MUST Be Functional Renders

The `.visual-preview` div must contain a **real rendered visual**, not a description or color swatch alone.

**For color/component decisions:**
Build an actual representative UI element (button group, stat card, data row, badge) using the option's colors. Show hover states inline if space permits. Example for a button:
```html
<div style="display:flex;gap:12px;flex-wrap:wrap;align-items:center;padding:8px 0">
  <button style="background:[COLOR];color:white;border:none;padding:10px 22px;border-radius:8px;font-size:14px;font-weight:600;cursor:pointer">Primary Action</button>
  <button style="background:transparent;color:[COLOR];border:2px solid [COLOR];padding:8px 20px;border-radius:8px;font-size:14px;font-weight:600;cursor:pointer">Secondary</button>
  <span style="background:[LIGHT_TINT];color:[COLOR];padding:4px 12px;border-radius:20px;font-size:12px;font-weight:600">Badge</span>
</div>
```

**For chart/data visualization decisions:**
Use Chart.js (load CDN only when needed). Each card has its own uniquely-ID'd canvas and its own Chart.js initialization in a `<script>` block at the bottom of the page. Use 6–8 data points with plausible labels ("Jan", "Feb", "Mar", "Apr", "May", "Jun" for time series; "Design", "Dev", "QA", "PM", "UX" for categorical). Never show an empty chart.

```html
<canvas id="chart-current" width="400" height="200"></canvas>
```

**For typography decisions:**
Load all fonts needed via Google Fonts in the `<head>`. Render a realistic text hierarchy:
- An H1 (e.g. "Welcome Back, Sarah")
- An H2 (e.g. "Your Dashboard")
- A body paragraph (2 sentences of realistic copy)
- A small caption/label
- A button
All styled in the option's font family.

**For layout decisions:**
Build a miniaturized replica (~0.6 scale using `transform: scale(0.6); transform-origin: top left`) of the layout structure using real CSS grid or flexbox — not a wireframe drawing.

### Required Page CSS

Include all of this CSS in the `<style>` tag:

```css
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
  background: #f1f5f9;
  color: #1a1a2e;
  min-height: 100vh;
  padding: 2rem;
}

header {
  text-align: center;
  margin-bottom: 2.5rem;
  padding-bottom: 1.5rem;
  border-bottom: 2px solid #e2e8f0;
}

header h1 {
  font-size: 1.4rem;
  font-weight: 700;
  color: #0f172a;
  letter-spacing: -0.02em;
}

.question {
  font-size: 1rem;
  color: #475569;
  font-style: italic;
  margin-top: 0.5rem;
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}

.instruction {
  margin-top: 1rem;
  font-size: 0.875rem;
  background: #eff6ff;
  color: #1d4ed8;
  padding: 0.6rem 1.25rem;
  border-radius: 8px;
  display: inline-block;
  border: 1px solid #bfdbfe;
}

.options-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.5rem;
  max-width: 1200px;
  margin: 0 auto;
}

.option-card.current {
  grid-column: 1 / -1;
}

.option-card {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0,0,0,0.08), 0 4px 16px rgba(0,0,0,0.04);
  border: 2px solid #e2e8f0;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
  display: flex;
  flex-direction: column;
}

.option-card:hover {
  border-color: #6366f1;
  box-shadow: 0 4px 20px rgba(99,102,241,0.12);
}

.option-card.current {
  border-color: #94a3b8;
}

.card-header {
  padding: 1rem 1.25rem 0.75rem;
  border-bottom: 1px solid #f1f5f9;
}

.option-label {
  font-size: 0.65rem;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  display: block;
  margin-bottom: 0.25rem;
}

.option-card.current .option-label { color: #64748b; }
.option-card.option-a .option-label { color: #7c3aed; }
.option-card.option-b .option-label { color: #0891b2; }
.option-card.option-c .option-label { color: #059669; }
.option-card.option-d .option-label { color: #dc2626; }

.option-title {
  font-size: 1.05rem;
  font-weight: 600;
  color: #0f172a;
}

.visual-preview {
  padding: 1.5rem;
  background: #f8fafc;
  min-height: 200px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex: 1;
}

.verdict {
  display: grid;
  grid-template-columns: 1fr 1fr;
  border-top: 1px solid #f1f5f9;
}

.pros, .cons {
  padding: 1rem 1.25rem;
}

.pros {
  border-right: 1px solid #f1f5f9;
}

.pros h3, .cons h3 {
  font-size: 0.65rem;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  margin-bottom: 0.5rem;
}

.pros h3 { color: #059669; }
.cons h3 { color: #e11d48; }

.verdict ul {
  list-style: none;
  padding: 0;
}

.verdict li {
  font-size: 0.8rem;
  color: #475569;
  line-height: 1.5;
  padding: 0.15rem 0;
  padding-left: 0.9rem;
  position: relative;
}

.pros li::before { content: "✓ "; color: #059669; font-weight: 700; position: absolute; left: 0; }
.cons li::before { content: "! "; color: #e11d48; font-weight: 700; position: absolute; left: 0; }

.card-footer {
  padding: 0.75rem 1.25rem;
  background: #f8fafc;
  border-top: 1px solid #f1f5f9;
}

.tell-claude {
  font-size: 0.75rem;
  color: #64748b;
  background: #f1f5f9;
  padding: 0.35rem 0.65rem;
  border-radius: 6px;
  display: block;
  font-family: 'SF Mono', 'Fira Code', 'Cascadia Code', monospace;
}

@media (max-width: 768px) {
  .options-grid { grid-template-columns: 1fr; }
  .option-card.current { grid-column: 1; }
}
```

---

## PHASE 6 — Open the Preview

After writing the file, run:

```bash
open .design-direction-preview.html
```

Then tell the user:

> "I've opened the design preview in your browser. It shows your current design plus 4 alternatives for [brief 5-word description of what was explored].
>
> When you've picked a direction, tell me:
> - **"I'll go with Option A"** (or B, C, D)
> - **"Keep the current one"**
> - **"Option B but [modification]"** — I'll apply your tweak on top
>
> I'll apply the changes to your source files."

**Wait for the user's response before doing anything else.**

---

## PHASE 7 — Apply the Selected Direction to Source Files

When the user responds with a choice:

### Step 7a — Parse the Selection

Map natural language to an option:
- "current" / "keep it" / "the original" / "none of them" → `current` (no changes)
- "A" / "option a" / "the first one" / the evocative name → `option-a`
- "B" / "option b" / "the second one" → `option-b`
- "C" / "option c" / "the third one" → `option-c`
- "D" / "option d" / "the fourth one" → `option-d`
- "option 1" / "option 2" etc. → treat number as letter (1→A, 2→B, 3→C, 4→D)

Note any modifier: "Option B **but make it darker**" — apply Option B, then apply the modifier.

### Step 7b — Handle "Keep Current"

If the user selects CURRENT or says "none" / "nevermind" / "keep what I have":
> "Got it — keeping the current design as-is. No files changed. Would you like to explore a different design decision?"

Stop here.

### Step 7c — Announce Changes Before Writing

Before editing any files, list the exact changes you're about to make:

> "Applying Option A ('Warm Coral') — here's what I'll change:
> - `src/components/Button.tsx` line 14: `background: '#4A90D9'` → `'#D9744A'`
> - `src/styles/globals.css` line 7: `--color-primary: #4A90D9` → `--color-primary: #D9744A`"

### Step 7d — Edit Surgically

Change **only** the values corresponding to the design element the user asked about. Do NOT:
- Restructure code
- Rename variables or functions
- Reformat unrelated code
- Add comments or documentation
- Touch files unrelated to the design decision

If the user specified a CSS custom property (token) → update the token, not individual usages.
If the user's codebase uses Tailwind classes → change the class names, not inline styles.

### Step 7e — Apply Modifier (if any)

If the user said "Option C but [modification]":
1. Apply Option C's values first
2. Then apply the modification on top
3. If the modification is unclear, ask ONE clarifying question before writing

### Step 7f — Confirm

After all changes are applied:

> "Done. Applied Option A ('Warm Coral') to:
> - `src/components/Button.tsx`
> - `src/styles/globals.css`
>
> Refresh your dev server to see the changes. Would you like to explore any other design decisions?"

---

## Edge Cases

**Non-web codebase detected:** No `.html`, `.css`, `.tsx`, `.jsx`, `.vue`, `.svelte` files found → warn the user, ask to confirm directory, do NOT generate a preview.

**Vague or empty arguments:** Ask ONE clarifying question before proceeding.

**Code spans 6+ files:** Note in the preview header: *"This element spans multiple files. The preview reflects values from `[primary file]`. When applying your selection, I'll update all relevant files."*

**Tailwind classes:** Show Tailwind class names in the preview comments (e.g. `bg-indigo-500`). When applying, change the class name, not the compiled CSS.

**CSS custom properties:** Always update the token in `:root` — not the individual usage sites.

**React-specific chart library** (Recharts, Victory, Nivo): Use Chart.js in the HTML preview (it's standalone). When applying the selection, translate design values to the actual library's prop format (e.g. Recharts `fill` prop, Victory `style` prop).

**Ambiguous selection:** "Did you mean Option A ('Ocean Blue') or Option B ('Electric Blue')?"

**User wants to explore a second decision:** After applying, if they want to explore another element, run the full workflow again from Phase 1 with the new question.
