# Setup: Playwright MCP + first reference batch

Three-phase walkthrough. Phase 1 is shell setup you run once. Phase 2 is a smoke test inside a fresh Claude Code session. Phase 3 is the first real reference-collection run, capped at 9 references so you can review quality before scaling.

---

## Phase 1 — One-time setup (terminal)

### 1. Verify Node.js

Playwright needs Node 18+.

```bash
node --version
```

If missing or too old (macOS):

```bash
brew install node
```

### 2. Install the Chromium binary that Playwright drives

```bash
npx playwright install chromium
```

One-time ~150MB download into your Playwright cache. Not into the repo.

### 3. Register the Playwright MCP server with Claude Code

Use a **project-scoped** MCP config so the server only loads when you're in the consultr repo. Create or edit `.mcp.json` at the repo root:

```bash
cd /Users/viniciusreginatto/GitHub/consultr
```

Then write this file to `.mcp.json`:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": [
        "-y",
        "@playwright/mcp@latest",
        "--viewport-size=1600,1000",
        "--device-scale-factor=2",
        "--headless"
      ]
    }
  }
}
```

Notes on the flags:
- `--viewport-size=1600,1000` — large enough to capture full charts at desktop sizes
- `--device-scale-factor=2` — Retina-quality screenshots; text stays sharp
- `--headless` — no visible browser window. Drop this flag if you want to watch what's happening (useful for debugging selectors).

Add `.mcp.json` to git (it's repo configuration, safe to share) but **NOT** any browser cookie/session files Playwright may create.

### 4. Restart Claude Code

Fully quit (`Cmd-Q` on macOS) and reopen. When you re-enter the consultr directory, Claude Code will offer to enable the project-scoped MCP server — approve it. Run `/mcp` inside Claude Code to confirm `playwright` shows as connected.

---

## Phase 2 — Smoke test (paste in a fresh Claude Code session)

Once Phase 1 is done and Claude Code is restarted, paste this prompt:

```
The Playwright MCP server should be available in this session. Please:

1. Confirm the playwright MCP tools are loaded (browser_navigate,
   browser_take_screenshot, or similar).
2. Navigate to https://example.com.
3. Take a screenshot.
4. Tell me the page <h1> text and confirm the screenshot was captured.

Do not save anything yet — this is just a smoke test for the connection.
```

**Expected outcome**: the model reports "Example Domain" as the h1 and confirms it took a screenshot. If it errors or says no MCP tools are loaded, debug before continuing:
- Run `/mcp` and check status
- Check `.mcp.json` syntax
- Restart again — MCP servers connect at startup

---

## Phase 3 — First batch (same session, after Phase 2 passes)

Paste this prompt:

```
You're collecting visual references for the ggconsulting R package's
archetype theme gallery. The full project context lives in
`/Users/viniciusreginatto/GitHub/consultr/consultr_plan_v2.html` and the
research methodology lives in
`/Users/viniciusreginatto/GitHub/consultr/prompts/references-research.md`.

Read both files first.

For THIS run, do a small batch only — exactly 9 references:
- 3 STRATEGY archetype references
- 3 FINANCE archetype references
- 3 EDITORIAL archetype references

The point of this small batch is to validate the workflow, catalog format,
and screenshot quality before scaling up.

For each archetype, aim for variety in chart type — across the 9, try to
capture: 1 waterfall or stacked-bar, 1 line/trend chart, 1 slope or
dumbbell, 1 simple bar, and ad-lib for the remaining 4.

PROCESS PER REFERENCE:

1. Use web search to find a candidate public source (URL) that fits the
   archetype. Suggested starting points by archetype:
   - Strategy: McKinsey Quarterly, BCG insights, Bain insights, Oliver
     Wyman publications, Roland Berger publications
   - Finance: Federal Reserve / ECB / BIS chart publications, IMF World
     Economic Outlook figures, large bank shareholder letters, IR decks
     from public companies
   - Editorial: The Economist Graphic Detail (free articles), FT Visual
     Data Journalism (free articles), Reuters Graphics, Bloomberg
     Graphics (free articles), Our World in Data

2. Use playwright MCP to navigate to the URL. If the page has multiple
   charts, find one that's representative of the archetype's visual
   language.

3. Screenshot the chart. Try to capture just the chart, not the
   surrounding article text. Use the browser_take_screenshot tool with a
   selector or coordinate region if available, or full-page and we'll
   crop later.

4. Save the screenshot to
   `/Users/viniciusreginatto/GitHub/consultr/ggconsulting/data-raw/references/{archetype}/ref-NNN-{slug}.png`
   where:
   - {archetype} is strategy | finance | editorial
   - NNN is zero-padded 3 digits (ref-001, ref-002, ...)
   - {slug} is a short kebab-case description (e.g., blue-monochrome-bars)
   - NEVER include the firm's name in the filename

5. Sample 3-5 representative hex colors from the chart. You can describe
   them in plain language ("a deep navy", "a warm gold") and approximate
   hex values — we'll refine in Prompt C later.

6. Write a YAML metadata file at
   `/Users/viniciusreginatto/GitHub/consultr/ggconsulting/data-raw/references/{archetype}/ref-NNN-{slug}.yml`
   following the schema in references-research.md (Shared conventions
   section).

7. Append a row to the catalog at
   `/Users/viniciusreginatto/GitHub/consultr/ggconsulting/data-raw/references/catalog.csv`.
   If the file doesn't exist, create it with this header:
   `id,archetype,chart_type,source_url,image_path,date_collected`

GUARDRAILS (re-read from references-research.md):
- No firm logos in screenshots — crop them out or pick a chart without
  visible logo
- No firm names in filenames or YAML
- Do not copy chart titles verbatim — paraphrase
- Describe fonts (e.g., "geometric sans, condensed") rather than naming
  proprietary ones
- Only public, freely accessible sources — no paywalled material

DELIVERABLE FORMAT WHEN DONE:

Output a markdown summary with:
- A bulleted list of the 9 references collected (id, archetype, chart
  type, source domain, one-line note)
- Any sources you tried that failed (paywall, no good charts, blocked)
- Any catalog-format or workflow issues to fix before scaling up

Stop after 9 references. Do not continue to the full Prompt A target
of 36 — we want to review this batch first.
```

---

## Tips after the first batch

1. **Open the saved PNGs and inspect them**. Are they sharp? Cropped well? Free of logos?
2. **Open the YAML files**. Are the observations specific enough? "Bold title, left-aligned, sans-serif" is good; "looks nice" is not.
3. **Check `catalog.csv`** opens cleanly in a spreadsheet — column count consistent, no commas in unescaped fields.
4. **Color sampling reliability**: image-based color sampling is often off by a few percent due to anti-aliasing. If colors matter (they do for Prompt C), plan to refine hex values manually in a later pass.
5. **If a source consistently fails** (paywall, anti-bot, JS-heavy), drop it from the list and find alternatives. Wikimedia Commons, Our World in Data, and government / central bank publications tend to be friction-free.
6. **Rate-limit yourself**. Add a `wait 3 seconds` instruction between page navigations if you scale up — protects against IP-blocking from sites that fingerprint headless browsers.

---

## Scaling up

Once the 9-reference batch looks good, run **Prompt A** from `references-research.md` in the same session (or a new one) to collect the remaining ~27 references toward the 36 target. After that, run Prompts B, D, C in that order.

If the workflow needed adjustments based on the batch review, update `references-research.md` first so the patterns are baked in before you run Prompt A at full scale.
