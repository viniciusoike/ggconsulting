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
│                      #   chart_type, source_url, one_line_note
├── briefs/            # per-publisher style syntheses (the main deliverable)
├── general/           # bulk screenshot corpus, named <publisher>-<chart>.png
├── strategy/          # early refs with deep-dive YAML annotations
└── finance/           # central-bank and multilateral chart packs
```

`chart_type` values: `bar | line | waterfall | slope | dumbbell | scatter |
area | stacked_bar | other`.

## Workflow

1. Drop new screenshots into `general/`, renamed to
   `<publisher>-<chart_type>[-qualifier].png`. Crop to the chart region
   (page furniture like nav bars out; the chart's own title/caption/source
   block stays in — it is part of the design being studied).
2. Add a `catalog.csv` row in the same step, while the page is still open.
   `source_url` is required for new rows. Three of the first 57 rows carry
   one, and the rest cannot be recovered, which is the whole argument for
   filling it at collection time rather than after.
3. When a publisher accumulates enough examples, write or update its brief in
   `briefs/`. Briefs, not per-image annotations, are where synthesis happens;
   reserve deep-dive YAML (see `strategy/`) for individual charts that earn it.

## Publisher → archetype mapping

| Publisher            | Archetype | Notes                                       |
| -------------------- | --------- | ------------------------------------------- |
| mckinsey             | strategy  | headline-as-takeaway, no-gridline bars      |
| fed, bis, imf, ecb   | finance   | print-report serif, dense panels, muted     |
| bloomberg            | finance   | counter-direction; see the note below       |
| ft                   | editorial | cream ground, direct labels, serif wordmark |
| economist            | editorial | warm-grey ground, red-led palette           |
| owid                 | editorial | white ground, muted categorical, annotation |

`theme_finance()` ships serif type at report density, which the central-bank
and multilateral chart packs match. Bloomberg points somewhere else, toward a
white ground with black as a series colour and one warm accent. `briefs/`
records both. Sample the institutions for refs that inform the current theme,
and treat Bloomberg refs as evidence for a screen-finance variant rather than
for `theme_finance()` as built.

## Coverage status (2026-09)

Counted by publisher, editorial is saturated at roughly 50 refs while strategy
holds 12 and finance 25. Counted by chart type the gap has narrowed
everywhere except where the planned constructors need it.

| Chart type  | strategy | finance | editorial |
| ----------- | -------- | ------- | --------- |
| line        | 2        | 8       | 20        |
| bar         | 1        | 2       | 8         |
| stacked_bar | 2        | 3       | 2         |
| area        | 0        | 1       | 8         |
| other       | 4        | 7       | 9         |
| scatter     | 1        | 4       | 2         |
| slope       | 0        | 0       | 1         |
| waterfall   | 2        | 0       | 0         |
| dumbbell    | 0        | 0       | 0         |

Waterfall, slope, and dumbbell are the three constructions `ctplot` will ship
as `ct_waterfall()`, `ct_slope()`, and `ct_dumbbell()`. Waterfall has two
strategy variants, a left-to-right running bridge and a descending two-anchor
bridge, but none in finance despite the bundled `ebitda_bridge` dataset
pointing straight at one. Slope has a single example and dumbbell none.
Collect against those three before adding volume anywhere else.

The finance refs also settle which institution the archetype should follow.
IMF is the closest match to `theme_finance()` as built: one legend shared
across stacked panels, mirrored tick dashes, a muted palette that holds up
across six series, and no panel fill. BACEN is a close second and validates
the pt-BR number formatting the package emits. BIS is worth reading for
structure only, since its grey panel fill and clashing categorical hues do
not survive contact with the archetype. OECD is the outlier: black bar
outlines, a headline colour outside the chart palette, and a palette that
changes between panels of the same figure.
