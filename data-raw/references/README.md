# Reference gallery

Design ground truth for `ggconsulting`'s three archetype themes
(`theme_strategy`, `theme_finance`, `theme_editorial`): a local corpus of
published charts from publishers whose house styles the archetypes draw on,
plus text syntheses that turn them into actionable theme decisions.

## Publication posture

- **Images are local-only.** Every `*.png` under this directory is
  `.gitignore`d and `.Rbuildignore`d: the charts are copyrighted works and are
  never committed, shipped in the package, or rendered on the pkgdown site.
- **Text is tracked.** `catalog.csv` and `briefs/*.md` contain *observations
  about* the designs (sampled hex values, typography conventions, layout
  rules). Facts about a style are not copyrightable and are safe to publish.
- In tracked text: paraphrase chart titles, never copy them verbatim, and
  don't assert proprietary font names as fact — describe the letterform and
  name a free equivalent.

## Structure

```
data-raw/references/
├── catalog.csv        # one row per image: filename, publisher, archetype,
│                      #   chart_type, source_url (optional), one_line_note
├── briefs/            # per-publisher style syntheses (the main deliverable)
├── general/           # bulk screenshot corpus, named <publisher>-<chart>.png
└── strategy/          # early refs with deep-dive YAML annotations
```

`chart_type` values: `bar | line | waterfall | slope | dumbbell | scatter |
area | stacked_bar | other`.

## Workflow

1. Drop new screenshots into `general/`, renamed to
   `<publisher>-<chart_type>[-qualifier].png`. Crop to the chart region
   (page furniture like nav bars out; the chart's own title/caption/source
   block stays in — it is part of the design being studied).
2. Add a `catalog.csv` row. `source_url` is optional — fill it when you have
   it, don't reconstruct it after the fact.
3. When a publisher accumulates enough examples, write or update its brief in
   `briefs/`. Briefs, not per-image annotations, are where synthesis happens;
   reserve deep-dive YAML (see `strategy/`) for individual charts that earn it.

## Publisher → archetype mapping

| Publisher   | Archetype  | Notes                                        |
| ----------- | ---------- | -------------------------------------------- |
| mckinsey    | strategy   | headline-as-takeaway, no-gridline bars       |
| bloomberg   | finance    | terminal-adjacent: white, black, orange      |
| ft          | editorial  | cream ground, direct labels, serif wordmark  |
| economist   | editorial  | warm-grey ground, red-led palette            |
| owid        | editorial  | white ground, muted categorical, annotation  |

## Coverage status (2026-07)

- editorial: ~50 refs (FT-heavy) — saturated
- strategy: 3 (mckinsey) — needs ~9 more; use `prompts/references-research.md`
- finance: 3 (bloomberg) — needs more; same route
