# Reference Gallery — Research Prompts

These prompts help build the visual reference catalog for ggconsulting's three archetype themes (`theme_strategy`, `theme_finance`, `theme_editorial`). Each prompt is self-contained — copy one into an LLM session with web search + image handling and run it.

**Target**: 30–50 total references across the three archetypes (≈10–15 per archetype).

**Local storage**: `consultr/ggconsulting/data-raw/references/` (already in `.Rbuildignore`).

---

## Shared conventions (referenced by all prompts)

### Folder structure to produce

```
data-raw/references/
├── catalog.csv                    # master index (one row per ref)
├── strategy/
│   ├── ref-001-blue-waterfall.png
│   ├── ref-001-blue-waterfall.yml
│   ├── ref-002-...
├── finance/
│   ├── ref-010-...
└── editorial/
    ├── ref-020-...
```

### Per-reference YAML schema

```yaml
id: ref-001
archetype: strategy          # strategy | finance | editorial
source:
  url: https://example.com/report.pdf
  publisher: "Public report — large strategy consultancy"  # generic; never name firms directly in files
  date_accessed: 2026-05-27
chart:
  type: waterfall            # bar | line | waterfall | slope | dumbbell | scatter | area | stacked_bar | other
  title_observed: "Generic description; do NOT copy verbatim from the source"
  aspect_ratio: "16:9"       # or 4:3 | square | custom
colors:
  - "#1B3A5C"                # observed hex values (sample from image)
  - "#2E86AB"
  - "#F18F01"
font:
  observed: "geometric sans, condensed, weights 400 and 700"  # describe; don't claim a proprietary name
  approximated_free_equivalent: "Inter or Source Sans 3"
typography:
  title_weight: "bold, larger than body, left-aligned, dark color"
  subtitle_treatment: "lighter weight, gray, sentence case"
  axis_labels: "small, gray, no bold"
  data_labels: "above bars, bold, primary color"
spacing:
  gridlines: "horizontal major only, very light gray"
  panel_margin: "generous"
  legend_position: "top, left-aligned"
annotation_style:
  data_labels: "shown on key bars only, formatted with thousand separator"
  callouts: "small arrow + text box pointing to one bar"
  source_note: "bottom-left, small, gray"
image_path: strategy/ref-001-blue-waterfall.png
notes: "Free-text observations — anything distinctive."
```

### Legal guardrails (every prompt)

- **Do NOT save firm logos.** If a logo is visible in the screenshot, crop it out before saving.
- **Do NOT copy chart titles verbatim.** Paraphrase or describe the context instead.
- **Do NOT name firms in filenames.** Use descriptive names like `ref-007-blue-monochrome-bars.png`, never `ref-007-mckinsey.png`.
- **Do NOT claim proprietary fonts.** When you observe a font, describe it ("a geometric sans") and propose a free equivalent.
- **Do NOT save material behind a paywall login.** Public reports, freely available PDFs, public press releases only.

### Quality bar for a reference

- Chart is from a real authoritative source (not a tutorial or stock image)
- Image is high-resolution (legible axis text)
- Chart is *representative* of the archetype, not an outlier
- You can extract at least: source URL, 3+ hex colors, chart type, one typography observation

---

## Prompt A — Broad archetype sweep (run first)

Use this prompt to collect 10–15 references per archetype as a starting catalog.

```
Role: visual reference researcher for an R package called ggconsulting, which
ships ggplot2 themes inspired by three archetypes of corporate visual identity.

Goal: collect 10–15 chart references for each of three archetypes. Save each as
a PNG image + a YAML metadata file under
`data-raw/references/{archetype}/`.

The three archetypes:

1. STRATEGY archetype — minimal, generous whitespace, sans-serif typography,
   navy/blue or muted dark palettes, left-aligned titles, no chart junk. Think:
   global strategy consultancies' publicly released reports and quarterly
   publications.

2. FINANCE archetype — denser layouts, subtle gridlines, classical typography
   (often serif for body, sans for axis), conservative palettes (blue/gray
   dominant, sometimes burgundy or forest green accent). Think: bank research
   notes, transaction advisory reports, financial statements in annual reports.

3. EDITORIAL archetype — warmer palettes (red, ochre, teal), more typographic
   personality (italics in subtitles, distinctive title fonts), heavier use of
   annotations, subtitle-as-takeaway pattern. Think: business journalism,
   research publications with editorial voice.

Suggested public sources (use web search to find current URLs):

- Strategy: McKinsey Quarterly insights, BCG public publications, Bain
  insights, Oliver Wyman publications, Roland Berger publications. Use search
  terms like "site:mckinsey.com chart 2024", "BCG insights waterfall chart",
  etc.
- Finance: public company annual reports (chart-heavy ones like Berkshire,
  JPM, Goldman shareholder letters), Federal Reserve / ECB / BIS chart
  publications, IMF World Economic Outlook figures.
- Editorial: The Economist Graphic Detail (free articles), FT Visual Data
  Journalism (free articles), Bloomberg Graphics (free articles),
  Our World in Data, Reuters Graphics.

Process for each reference:

1. Search for a candidate chart matching one archetype's visual language.
2. Open the source page, locate the specific chart.
3. Screenshot or download the chart image. Crop out any logos.
4. Save the PNG to `data-raw/references/{archetype}/ref-NNN-{slug}.png` where
   NNN is a 3-digit zero-padded sequence and slug is a brief descriptor
   (e.g., ref-007-blue-monochrome-bars.png). NEVER put a firm name in the
   filename.
5. Sample 3+ representative hex colors from the chart (use any image color
   picker).
6. Write a YAML metadata file to `data-raw/references/{archetype}/ref-NNN-{slug}.yml`
   following the schema in the prompt below.
7. Append a row to `data-raw/references/catalog.csv` with columns:
   id, archetype, chart_type, source_url, image_path.

YAML schema:

[PASTE THE SHARED YAML SCHEMA FROM ABOVE HERE]

Legal guardrails:

[PASTE THE SHARED GUARDRAILS FROM ABOVE HERE]

Targets:
- 12 references for STRATEGY
- 12 references for FINANCE
- 12 references for EDITORIAL
- Across each archetype, aim for variety in chart type (bars, lines, slope,
  waterfall, dumbbell, scatter, stacked, area). Try to cover at least 4
  chart types per archetype.

Deliverable: a populated `data-raw/references/` directory + a markdown summary
listing what you collected and any archetypes/chart-types where you fell short
of the target.
```

---

## Prompt B — Chart-type focused (run after Prompt A)

Use this prompt when you specifically need more examples of waterfall, slope, and dumbbell charts — the three constructions ctplot will ship as `ct_waterfall`, `ct_slope`, `ct_dumbbell`.

```
Role: visual reference researcher.

Goal: find at least 5 high-quality real-world examples of EACH of these three
chart types, distributed across the three archetypes (strategy / finance /
editorial). Total target: 15+ references.

Chart types of interest:

1. WATERFALL (bridge chart) — sequence of value contributions from one total
   to another, with connecting lines between bars and a starting/ending total
   bar. Often used for revenue bridges, profit walks, headcount reconciliation.

2. SLOPE chart — two points connected by a line for each category, comparing
   value at time A vs time B. Often used for "before/after intervention",
   "rank change", or "two-period comparison" stories.

3. DUMBBELL chart (a.k.a. lollipop pairs) — two points per category connected
   by a segment, used for gap analysis. Often used for actual-vs-target,
   benchmark-vs-firm, or two-period comparison.

For each example, follow the YAML schema and folder structure described in the
shared conventions (below). Pay particular attention to:

- How total/anchor bars are visually distinguished in waterfalls
- Color treatment for positive vs negative deltas
- Whether connecting lines / connectors are dashed, solid, or absent
- Endpoint labeling style in slope charts
- Connector segment color and weight in dumbbells
- Sort order conventions

Public sources to try:

- Annual reports of large public companies (rich in waterfalls for earnings
  walks)
- Strategy consultancy publications (rich in slope charts)
- Equity research notes available publicly (rich in dumbbells)
- The Economist, FT, Bloomberg (occasional uses of all three)
- Investor presentations on company IR pages

YAML schema:

[PASTE THE SHARED YAML SCHEMA FROM ABOVE HERE]

Legal guardrails:

[PASTE THE SHARED GUARDRAILS FROM ABOVE HERE]

Deliverable:
- 5+ references per chart type, saved into the existing
  `data-raw/references/{archetype}/` structure with continuing ref-NNN
  numbering.
- A markdown summary highlighting the *visual idioms* you observed for each
  chart type — sort order, color conventions, connector styles, label
  placement. This summary will feed directly into the ctplot constructor
  defaults.
```

---

## Prompt C — Color palette extraction

Use this prompt to focus on building the palette files for ggconsulting (`strategy_navy`, future palettes, CVD-safe variants).

```
Role: color systems researcher.

Goal: from the existing reference catalog at `data-raw/references/`, extract
and synthesize palette candidates for each archetype. Add new references only
if the existing catalog is short on color diversity within an archetype.

For each archetype, produce:

1. A primary palette (6 colors) — qualitative/categorical, designed to read
   well in a default theme.
2. A monochrome palette (5 tints of one main color) — for monochromatic charts
   where category differentiation is by shade.
3. A diverging palette (5 colors, with white/light middle) — for charts
   showing positive/negative deviation from a reference point.
4. A CVD-safe variant of (1) — verifiable via color-blind simulators.

Process:

1. Read every YAML file in `data-raw/references/{archetype}/`.
2. Aggregate observed hex values per archetype.
3. Cluster by perceptual similarity. Pick representative anchor colors.
4. Generate the four palette outputs above. Each palette should:
   - Have decent contrast against a white background
   - Differentiate clearly when printed at small sizes
   - Avoid pure black or pure saturated red unless idiomatically used (the
     editorial archetype is allowed saturated red)
5. Validate the CVD-safe variant by simulating deuteranopia, protanopia, and
   tritanopia (use any standard simulator — viz-palette, coolors, or describe
   the check).

Output a single YAML file at `data-raw/palettes-draft.yml`:

```yaml
strategy:
  primary:   ["#...", "#...", "#...", "#...", "#...", "#..."]
  monochrome: ["#...", "#...", "#...", "#...", "#..."]
  diverging:  ["#...", "#...", "#...", "#...", "#..."]
  cvd_safe:   ["#...", "#...", "#...", "#...", "#...", "#..."]
finance:
  # ... same structure
editorial:
  # ... same structure
```

Plus a markdown explanation file `data-raw/palettes-rationale.md` documenting:
- Which reference IDs informed each palette
- Why specific colors were chosen
- Notes on CVD simulation results
- Any compromises made

Legal guardrails:

[PASTE THE SHARED GUARDRAILS FROM ABOVE HERE]

Important: do NOT reproduce a specific firm's exact corporate palette. Use the
references as inspiration to design palettes in the *family* of each
archetype's visual language — not clones.
```

---

## Prompt D — Annotation and typography patterns

Use this prompt for the qualitative aspects: how titles, subtitles, data labels, source notes, and callouts are treated. These observations inform `ct_finish()` defaults and theme typography settings.

```
Role: visual systems researcher.

Goal: from the existing reference catalog at `data-raw/references/`, produce a
structured analysis of typography and annotation patterns per archetype. No
new references required (but add up to 5 if you find a notable pattern gap).

For each archetype, observe and document:

1. TITLE TREATMENT
   - Position (left / center / above-axis)
   - Weight and relative size (vs body text)
   - Color (true black, dark gray, dark brand color)
   - Case (sentence / title / all caps)
   - Length convention (short headline vs full statement)

2. SUBTITLE TREATMENT
   - Whether present at all
   - Role (descriptive metadata, takeaway statement, time period note)
   - Visual contrast vs title (weight, color, size)

3. AXIS TREATMENT
   - Tick density
   - Label rotation conventions
   - Whether axis titles are used or implied via subtitle
   - Tick line presence / absence
   - Decimal precision in axis labels

4. DATA LABELS
   - Where placed (above bars, inline, at endpoints)
   - On every data point or selective
   - Formatting (thousand separator, decimals, units)
   - Visual weight (regular, bold)

5. CALLOUTS
   - Pattern (text box + arrow / shaded region / single label)
   - Frequency (used heavily / rare / never)
   - Visual treatment (boxed / unboxed)

6. SOURCE NOTES
   - Position (always bottom-left? bottom-right?)
   - Format ("Source: X" vs "Note: ...")
   - Visual treatment (italic, small gray)

7. NEGATIVE VALUE TREATMENT
   - Color (red? minus sign? both?)
   - Parens accounting style appearance

For each archetype, produce a markdown report at
`data-raw/typography-{archetype}.md` with:

- A patterns summary (the observations above)
- Recommended defaults for ggconsulting's `theme_{archetype}()` based on the
  patterns (e.g., "title should be face='bold', hjust=0, size 1.2x base,
  color='#0D1B2A'")
- Recommended defaults for `ct_finish()` behavior per archetype (e.g., "in
  the editorial archetype, prefer in-context callout boxes; in finance,
  prefer footnote-style annotations")

Legal guardrails:

[PASTE THE SHARED GUARDRAILS FROM ABOVE HERE]

This is observational and qualitative — there is no right answer, but be
specific. "The title is usually bold and left-aligned" is OK; "the title is
nice" is not.
```

---

## Tips for running these prompts

1. **Run sequentially**: A → B → C → D. Each builds on the prior catalog.
2. **Dedupe**: before saving a new reference, check `catalog.csv` to ensure you're not collecting two very similar charts from the same source.
3. **Don't aim for completeness in one session**: 5–10 high-quality references beat 30 mediocre ones. Quality over volume.
4. **Verify image color samples**: image-based color sampling can be lossy due to PNG compression or anti-aliasing. Cross-check with at least 2 sampled points per color.
5. **Cap each archetype at ~15 refs**: more is rarely useful; you'll be referencing the catalog frequently and want it scannable.
6. **Commit the catalog to git but `.Rbuildignore` it**: it's design ground truth, not user-facing data. Already configured in the package.
7. **Re-run Prompt D after every major palette change**: typography and palette are coupled — a new palette may justify different default colors in `ct_finish()`.
